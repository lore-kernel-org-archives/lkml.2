Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab2CLBxl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 21:53:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32114 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2CLBxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 21:53:34 -0400
X-AuditID: cbfee612-b7c09ae0000024ca-27-4f5d571ca803
Date: Mon, 12 Mar 2012 01:53:32 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH 0/3] power: max17042_battery: Add DT bindings
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: DirkBrandewie <dirk.brandewie@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "AntonVorontsov<cbou"@mail.ru, "DavidWoodhouse<dwmw2"@infradead.org
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120312013452496@myungjoo.ham
Msgkey: 20120312013452496@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120312013452496@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <17763564.55121331517212251.JavaMail.weblogic@epml04>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2C1sQd1009956

Karol Lewandowski<k.lewandowsk@samsung.com>, 2012-03-10 02:32 (GMT+09:00)
> Dear MungJoo,
> 
> I wasn't aware of Dirk's patchset and thus, I didn't ever try to make my
> patches compatible with it.
> 
> I've found hopefully correct patchset[1] via google - it's mailing list
> posting without any feedback...  I've checked linux-next and it clearly
> hasn't been merged.
> 
> I'm happy to rework my patch but I would like to ask you about specific
> tree I should base on.  Is this patchset in some subsystem-specific
> (power?) tree? Other?

Dear Karol,

I preferred Dirk's patchset included because it is for the correctness of the device driver.

However, as Dirk's patchset has not been updated or merged for long, I guess you may go ahead trying to merge this DT patchset first.

It appears that this patchset does not force much trouble for Dirk's side as the two are virtually disjoint and it seems rebasing Dirk's patchset upon this patchset trivial though I didn't try that yet.

Anyway, please consider "Acked-by" from me for the patches.


Cheers!
MyungJoo.

> 
> [1] https://lkml.org/lkml/2012/1/24/237
> 
> Regards,
> -- 
> Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
> 
> On 09.03.2012 01:16, ÇÔ¸íÁÖ wrote:
> 
> > Dear Karol Lewandowski,
> > 
> > I've been confused this patchset with Dirk Brandewie's MAX17042 patchset; I though this was a follow-up version of Dirk's, which I think already acked by me.
> > 
> > Anyway, the patches themselves look fine.
> > 
> > However, have you checked the compatibility (mergability?) with the recent MAX17042 patches of Dirk Brandewie? I'm not sure about the merge status of Dirk's patchset, but, I think you need to consider his patches as they massively reshaped the device driver.
> > 
> > Other than that, the patches look fine. (If that issue is already considered, regard this as an Acked-by.)
> > 
> > Thank you.
> > 
> > 
> > Cheers!
> > MyungJoo.
> > 
> > ------- Original Message -------
> > Sender : Karol Lewandowski Junior Software Engineer/SPRC-Linux (MSD)/»ï¼ºÀüÀÚ
> > Date : 2012-03-08 19:32 (GMT+09:00)
> > Title : Re: [PATCH 0/3] power: max17042_battery: Add DT bindings
> > 
> > Dear MyungJoo Ham,
> > 
> > Could you take a look at patchset I've sent? It's needed to make use of
> > max17042 driver on device tree-enabled platforms.
> > 
> > Regards,
> 
> 
> 
> 
> 

--

MyungJoo Ham (ÇÔ¸íÁÖ), PHD

System S/W Lab, S/W Platform Team, Software Center
Samsung Electronics
Cell: +82-10-6714-2858



 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
