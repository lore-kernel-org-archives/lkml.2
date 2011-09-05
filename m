Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1IEBYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 21:24:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26154 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1IEBYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 21:24:40 -0400
X-AuditID: cbfee60c-b7c75ae00000094d-51-4e6424d4c4b0
Date: Mon, 05 Sep 2011 01:24:36 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCHv1 1/1] [Power Supply]: Fix error handling in max17042 fuel
 gauge
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20110905011948087@myungjoo.ham
Msgkey: 20110905011948087@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110905011948087@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <18021216.478661315185875229.JavaMail.weblogic@epml15>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p851OoKm005642

Sender : Ramakrishna Pallala<ramakrishna.pallala@intel.com> Date : 2011-09-02 15:45 (GMT+09:00)
> 
> In max17042_get_property(...), the values returned by
> max17042_read_reg are directly assigned to the variables,
> even if the read results in an error.
> 
> This patch checks for the return code from max17042_read_reg and
> exits the function if there is any error.
> 
> Signed-off-by: Ramakrishna Pallala 
> ---
> drivers/power/max17042_battery.c |   85 ++++++++++++++++++++++++++------------
> 1 files changed, 58 insertions(+), 27 deletions(-)
> 

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
