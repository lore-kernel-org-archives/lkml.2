Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab2FTEcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 00:32:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43050 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2FTEcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 00:32:12 -0400
X-AuditID: cbfee60d-b7f056d000004fc9-f8-4fe152475d53
Date: Wed, 20 Jun 2012 04:32:07 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH 1/2] extcon: Set platform drvdata in
 gpio_extcon_probe() and fix irq leak
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Lockwood <lockwood@android.com>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120620043143336@myungjoo.ham
Msgkey: 20120620043143336@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120620043143336@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <25919571.619021340166725967.JavaMail.weblogic@epml24>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t/tmbruQQ/9Deb3cVpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MVx8+MBV84q24cfo0WwPjAd4uRk4OIQF1iUVLTrKB2BICJhK7
	dh5jhbDFJC7cWw8U5wKqmc8ocaCtH6yIRUBVYvqj+UBFHBxsAnoSMz8ng4SFBRIlTnQ+ZAax
	RQRMJSZdvsYOYjMLbGSS+Pu4AmKXksSafa9YQGxeAUGJkzOfsEDsUpU4Pe85G0RcTeLv7slQ
	cQmJWdMvQN3DKzGj/SlUXE5i2tc1zBC2tMT5WRsYYW5e/P0xVJxf4tjtHUwgZ4L0PrkfDDNm
	9+YvUO8KSEw9cxCqVUui+f8qqDifxJqFb1lgxuw6tZwZ4hVFiSndD6He0pL48mMfG7pXeAWc
	JDa3vGKawCg7C0lqFpL2WUjakdUsYGRZxSiaWpBcUJyUnmqsV5yYW1yal66XnJ+7iREczc94
	dzDObbA4xCjAwajEw9sg9NBfiDWxrLgy9xCjBAezkghv/5cH/kK8KYmVValF+fFFpTmpxYcY
	pTlYlMR5p1hf8BcSSE8sSc1OTS1ILYLJMnFwSjUwbksJT7dx/vg833CaguTZsulLlvur1K/l
	PX1Pcgp/hfK717lcFeaNryYejnuyZ88v/xmzJ1rx/fFJUH2qK3+wRbrc62e158MY0zi59DzW
	gi7/lFU9kQcP6Lo2Nz+WrC5wbBV/+LzC4rLY3VaGV0dePJhz0cWv/8IM0bkdMe3fp17/WWQj
	wvZPiaU4I9FQi7moOBEA77sV6uICAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5K4WJZO032271

> On Tue, Jun 19, 2012 at 10:19:07AM +0000, «‘∏Ì¡÷ wrote:
> > > Add missing platform_set_drvdata() in gpio_extcon_probe(), otherwise calling
> > > platform_get_drvdata in gpio_extcon_remove() returns NULL.
> > > 
> > > Also add missing free_irq call in gpio_extcon_remove().
> > > 
> > > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > 
> > Thanks!
> > 
> > 
> > Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > 
> > I'll apply this patch to the extcon-for-next.
> > I would appear in http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next soon after syncing servers.
> 
> Does this mean you are going to have a separate extcon git tree
> somewhere, feeding into linux-next, and sending stuff directly to Linus?
> 
> I don't see an entry in the MAINTAINERS file saying this, which is why I
> was picking up extcon patches, should I not be doing this?
> 
> confused,
> 
> greg k-h
> 

You are right. We do not have MAINTAINERS entry for extcon.

I can wait until we have MAINTAINERS entry registered for extcon, which we have not request or submit, yet. Until then, I think you may pick up the extcon patches and I will simply follow your repositories (keep rebasing from yours)

Sorry for the confusion.


MyungJoo



ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
