Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1HYRHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:07:50 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:45368 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754593Ab1HYRHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:07:48 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: PB6XwaQVM1mn4K2ffgZ.coIDNbuJUOTyV1DgSvioJ2DOVzg
 hHN89U_0ale5Yo0RB4kmR7kp4M4_dMIhR9ks23ExYrxDQlN98SqY50CEX6fF
 2MM_BjBWDF9gbR5Z6YcexcHzi8mgXyib3t9BnST_xwNbC5eQedOJTwQ0fxF3
 sDIK.VspKYN7fTr2lIsDHpFdaUR1uBhuOrsleoge1ePxDJo4oJ2xTspVSLPI
 DE4BI7mVzlFHPNvUje4emNBJRMaPa.63djqsLKCiiPNaXjFp8hjaHwPCdH4j
 xGaxHF36NgcvCEhF8MAgSeC87T66QI0BYdj2_hQw8wFCE0VdtuZFB5pqsw3x
 h.82xdaDxSpR5RK_lf13CGN1r73OD09z4BILqGaEHKq5MndkOgHJPhoLboMH
 8vdrAS88mVfZoP1Vbq_TvxQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 25 Aug 2011 12:07:44 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: James Bottomley <James.bottomley@HansenPartnership.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
In-Reply-To: <986ca4ed-6810-426f-b32f-5c8687e3a10b@email.android.com>
Message-ID: <alpine.DEB.2.00.1108251206440.27407@router.home>
References: <1313650253-21794-1-git-send-email-gthelen@google.com> <20110818144025.8e122a67.akpm@linux-foundation.org> <1314284272.27911.32.camel@twins> <alpine.DEB.2.00.1108251009120.27407@router.home> <1314289208.3268.4.camel@mulgrave>
 <alpine.DEB.2.00.1108251128460.27407@router.home> <986ca4ed-6810-426f-b32f-5c8687e3a10b@email.android.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011, James Bottomley wrote:

> >ARM seems to have these LDREX/STREX instructions for that purpose which
> >seem to be used for generating atomic instructions without lockes. I
> >guess
> >other RISC architectures have similar means of doing it?
>
> Arm isn't really risc.  Most don't.  However even with ldrex/strex you need two instructions for rmw.

Well then what is "really risc"? RISC is an old beaten down marketing term
AFAICT and ARM claims it too.

