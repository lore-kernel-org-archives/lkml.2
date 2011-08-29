Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab1H2F6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 01:58:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39301 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1H2F6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 01:58:17 -0400
X-AuditID: cbfee60e-b7b35ae000003d76-06-4e5b2a753de0
Date: Mon, 29 Aug 2011 05:58:13 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: RE: [Power-supply]: Error handling in max17042_battery.c
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20110829055616441@myungjoo.ham
Msgkey: 20110829055616441@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110829055616441@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <7455484.255921314597492899.JavaMail.weblogic@epml19>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7T5wP1i015466

I guess your spam filter filtered out my reply..?

The reply posted 3 days ago: https://lkml.org/lkml/2011/8/26/32

In short, please go ahead.


Cheers
MyungJoo

------- Original Message -------
Sender : Pallala, Ramakrishna<ramakrishna.pallala@intel.com>
Date : 2011-08-29 14:30 (GMT+09:00)
Title : RE: [Power-supply]: Error handling in max17042_battery.c

> Hi All,
> 
> I am working on the I2C based max17042 fuel gauge driver
> Which is drivers/power/max17042_battery.c
> 
> In max17042_get_property(...), the values returned by
> Max17042_read_reg are directly assigned to the variables,
> even if the read results in an error. Shouldn't we check
> for the 'correctness' of the returned values and then
> assign them ? Can I submit a patch to change this ?
> 
> Or Is this done intentionally ?

Any inputs on this?

Thanks,
Ram



 MyungJoo Ham (ÇÔ¸íÁÖ)
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
