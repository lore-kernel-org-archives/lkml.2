Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab1HZGcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 02:32:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20030 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab1HZGci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 02:32:38 -0400
X-AuditID: cbfee612-b7c20ae0000068b3-e4-4e573df80c73
Date: Fri, 26 Aug 2011 06:32:24 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [Power-supply]: Error handling in max17042_battery.c
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20110826062713310@myungjoo.ham
Msgkey: 20110826062713310@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110826062713310@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <11719608.199941314340343549.JavaMail.weblogic@epml19>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7Q6WnSp010850

Sender : Pallala, Ramakrishna<ramakrishna.pallala@intel.com> Date : 2011-08-26 14:46 (GMT+09:00)
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
> 
> Thanks,
> Ram
> 

Hello,

I did not ignore and return the error values from max17042_read_reg() intentionally, I've just missed them somehow (maybe was too lazy that day?). 

Handling errors from max17042_read_reg() at the side of max17042_get_property() is a feature missing. And, I'd be much appreciated if you'd send the patch you've mentioned.

Thank you,
MyungJooÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
