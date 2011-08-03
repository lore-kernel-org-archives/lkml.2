Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1HCAzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 20:55:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31382 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab1HCAzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 20:55:07 -0400
X-AuditID: cbfee610-b7ce5ae00000749c-1f-4e389c69408c
Date: Wed, 03 Aug 2011 00:55:05 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: regulator: max8952 init a mutex but never use it
To: Liam Girdwood <lrg@ti.com>, Axel Lin <axel.lin@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        myungjoo.ham@gmail.com
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20110803004927278@myungjoo.ham
Msgkey: 20110803004927278@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110803004927278@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <18774335.313851312332903932.JavaMail.weblogic@epml15>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p730tMgg001161

Sender : Liam Girdwood<lrg@ti.com> / Date : 2011-08-02 22:41 (GMT+09:00)
> On 02/08/11 13:16, Axel Lin wrote:
> > hi,
> > The max8952 regulator driver init a mutex but never use it,
> > do we really need the mutex? Or should we just remove it?
> > 
> 
> It can be removed if it is not being used anywhere.
> 
> Liam
> 
> 

Yes, that should be removed. It is something that was used with removed code before sending the patch.

Thank you.


Cheers!
MyungJoo

 MyungJoo Ham (ÇÔ¸íÁÖ)
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
