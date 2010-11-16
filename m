Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934180Ab0KPKEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:04:50 -0500
Received: from nm9-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.196]:20492 "HELO
	nm9-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932972Ab0KPKEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:04:46 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 943105.89558.bm@omp1039.mail.sp2.yahoo.com
Message-ID: <334828.67526.qm@web113308.mail.gq1.yahoo.com>
X-YMail-OSG: qYbRbkYVM1nZQXpQ1tY5p4eDLAnAWSW3dTfRQjfr5cHg1km
 6OeaLTYkh5m2g3kzP4Mbzs.J9b7j9mO5uWhJxuIvdgoFNo26IZER97WE0MPx
 QiV7kUqU3YIHJQm63oxS_DVL4VwhJVW6mm_a.n7aaVRjCw0xc1_0ekZZgfKj
 77qfxzLuHZ.sPY216qOoIjcVvDPJwy2.iW2dSigAc3VxmE_NbkwWY2XGCSNJ
 Kxi6a3lCLz_9n8ltysLSJT2s0ml7ihVZvi4NaiptFDjsDUTK2QN_OvayKILB
 J1fAKUBEJr_ccdzZBZlofatHcMbbWpf7qolr4cd1AUIfyldBMUwbzKcrmCoE
 .XyTF_6cIx0UGMm6UWTvCdjEYKsY-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/504.5 YahooMailWebService/0.8.107.285259
References: <20101115093410.BEFD.A69D9226@jp.fujitsu.com> <20101114181905.bc5b44f9.akpm@linux-foundation.org> <20101115113238.BF06.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com> <alpine.LNX.2.00.1011160027180.22346@swampdrago <alpine.DEB.2.00.1011151602090.29081@chino.kir.corp.google.com>
Date: Tue, 16 Nov 2010 02:04:44 -0800 (PST)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: [PATCH] Revert oom rewrite series
To: David Rientjes <rientjes@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1011151602090.29081@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC trimmed for sanity ...

----- Original Message ----

> From: David Rientjes <rientjes@google.com>
> To: Jesper Juhl <jj@chaosbits.net>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>; Andrew Morton 
><akpm@linux-foundation.org>; Linus Torvalds <torvalds@linux-foundation.org>; 
>LKML <linux-kernel@vger.kernel.org>; Ying Han <yinghan@google.com>; Bodo Eggert 
><7eggert@web.de>; Mandeep@yahoo.com
> Sent: Tue, November 16, 2010 1:06:21 AM
> Subject: Re: [PATCH] Revert oom rewrite series
> 
> 
> Thanks for the report!  I'll get  involved with kde-devel and send a patch 
> to remove this dependency on newer  kernels to expedite the process.
> 
>  [ Others with reports of deprecated use  of oom_adj can contact me 
>    privately and I'll find the parties of  interest to avoid topics 
>    unrelated to the kernel itself on LKML.  ]
David,

 another one for your collection. You asked for it :-) This is CentOS-5.5 
running on top of kernel 2.6.36, likely out of initrd:

$ dmesg | grep deprecated
[    2.430330] nash-hotplug (67): /proc/67/oom_adj is deprecated, please use 
/proc/67/oom_score_adj instead.

Cheers
Martin
