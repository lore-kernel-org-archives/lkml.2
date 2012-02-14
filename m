Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920Ab2BNPEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 10:04:34 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:46259 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756682Ab2BNPEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:04:33 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Kn9lPNsVM1mcrtQZ_FA_cYNWYermzJBnpgmpioJQLtvZTIr
 ZB6FFlYzhVg3NTXcWigBjRvMMyUTtOUPLeySTxXNukHX64BHwd5yrUXw2Mx1
 WtP.JyBzwnBsMfl0Uy9hF4zC0MjHAMynx5bWQx.bpTFhlbkKAfrBzw3T5.4n
 uDizylCd5vitb4on0Fz_p_bSGdaZ2uavWOfpZjdBh03LFTVclXfXXpQL7iDI
 ErbWzNo3xCfuY3DhT6L.0YL71VnBiqEdjc4qW_gSQOu1XOf8XbysAiGUkQd8
 yyX7ZXNZsbv9Un_Y1ZlNJf5xI3D9IhuK_JI20_ZLxwxj8QvqYSAZdftW0yEY
 L4NAQWZKXsXAYbNT1c4pjo6U6qH_S1PtBLJhzLNerX7H8AkHD676Hl2yn9aI
 -
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 14 Feb 2012 09:04:30 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Yang Bai <hamo.by@gmail.com>, mpm@selenic.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] slab: warning if total alloc size overflow
In-Reply-To: <alpine.LFD.2.02.1202140929040.2721@tux.localdomain>
Message-ID: <alpine.DEB.2.00.1202140904040.20013@router.home>
References: <1329204499-2671-1-git-send-email-hamo.by@gmail.com> <alpine.LFD.2.02.1202140929040.2721@tux.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Pekka Enberg wrote:

> Did you check how much kernel text size increases? I'm pretty sure we'd need
> to wrap this with CONFIG_SLAB_OVERFLOW ifdef.

Remove the inlining? This function is rarely called and not performance
critical.

