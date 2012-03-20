Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124Ab2CTOJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:09:05 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:24001 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759544Ab2CTOJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:09:03 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: iKyTVnQVM1ke1hJSuGa7IfPWGzYwF7gEAUQcwPukKyqmSqO
 AhCyHETvMR6SPPHxyYO6XNYql5sfuRaqEs2lSZM45PbG1_k8qxFp_gzu4nxp
 R5u9qZbD3K1vgMRHDMrOlhN20XHZ5xXAtB2RTyAowAH13P1OmSsUFJh5uKKi
 .52GIQSNO1TamsCTEdfnFeYitljVirponMj3ECAdcAZDG1RrJjwMtDOOINYZ
 M8Q176ZpJca2.TC8JSJkbMXZj7yhUtHgZ4Ys.kEQEGWWKbhQEf8omyuBwovs
 hdqhWzwp2fdJ5eisBrHg0t6j86iYlXbNXQsocpKhPR6hf3UII7eSwl_JPHYE
 cg5ahworjWt1xIJlfsmx61v_ELn0jW8OW1albyIqHcNUb9d9y5Ta5TNBsQaL
 yzxbmp_VAWDZQdZ.4HUG_yVJNKElVQwXU1sKi
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Mar 2012 09:08:59 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Michal Nazarewicz <mina86@mina86.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/6] kenrel.h: add ALIGN_OF_LAST_BIT()
In-Reply-To: <CACVxJT_UVRjkSK+kieYVpO4R+D-4S2bXaoK-apxMkuFAYsgi_A@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1203200908330.19333@router.home>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com> <1332238884-6237-2-git-send-email-laijs@cn.fujitsu.com> <op.wbgvn00x3l0zgt@mpn-glaptop> <CACVxJT_UVRjkSK+kieYVpO4R+D-4S2bXaoK-apxMkuFAYsgi_A@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1987152897-1332252541=:19333"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1987152897-1332252541=:19333
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 20 Mar 2012, Alexey Dobriyan wrote:

> >> +#define ALIGN_OF_LAST_BIT(x) =C2=A0 ((((x)^((x) - 1))>>1) + 1)
> >
> >
> > Wouldn't ALIGNMENT() be less confusing? After all, that's what this mac=
ro is
> > calculating, right? Alignment of given address.
>
> Bits do not have alignment because they aren't directly addressable.
> Can you hardcode this sequence with comment, because it looks too
> special for macro.

Some sane naming please. This is confusing.

---1463811839-1987152897-1332252541=:19333--
