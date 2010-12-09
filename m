Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0LIDiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 22:38:06 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:39597 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab0LIDiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 22:38:04 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <201011301754.17829.arnd@arndb.de> <011401cb96c0$b7dca8d0$2795fa70$@mprc.pku.edu.cn> <201012081353.44927.arnd@arndb.de>
In-Reply-To: <201012081353.44927.arnd@arndb.de>
Subject: RE: [PATCH] Unicore architecture patch review, part 2
Date: Thu, 9 Dec 2010 11:37:58 +0800
Message-ID: <017801cb9752$79a48a50$6ced9ef0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQEGWQxFgenXGrFHNnUO9LkE1o8/SQGsRI17Ac4HSG+VBhzd4A==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-arch-owner@vger.kernel.org [mailto:linux-arch-
> owner@vger.kernel.org] On Behalf Of Arnd Bergmann
> Sent: Wednesday, December 08, 2010 8:54 PM
> To: Guan Xuetao
> Cc: linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Unicore architecture patch review, part 2
> 
> On Wednesday 08 December 2010, Guan Xuetao wrote:
> 
> > > > @@ -0,0 +1,390 @@
> > > > +/* 0 */		CALL(sys_restart_syscall)
> > > > +		CALL(sys_exit)
> > > > +		CALL(sys_fork_wrapper)
> > > > +		CALL(sys_read)
> > > > +		CALL(sys_write)
> > > > +/* 5 */		CALL(sys_open)
> > > > +		CALL(sys_close)
> > >
> > > When you start using the generic unistd.h file, you can also replace
> > > this table with something like arch/tile/kernel/sys.c.
> > Well. I will use the generic unistd.h in UniCore-64 version.
> 
> I thought you had agreed to break ABI compatibility with your existing
code
> base and use the generic ABI everywhere.
> 
> Did I misunderstand you or did you make up your mind since then?
> 
We do define new 32-bit ABI work at present, and I will use generic unistd
in new ABI.
But existing machines must be maintained, so many codes need remain
compatibility.
Then, it would be a long-term work, and 64-bit coding will be before that.

Guan Xuetao

