Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab0LGJul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:50:41 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:26441 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754616Ab0LGJuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:50:40 -0500
Message-ID: <175BA60FBA444BE6B858D42E7B602A40@hacdom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: "Wolfgang Grandegger" <wg@grandegger.com>,
        <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, <andrew.chih.howe.khor@intel.com>,
        <joel.clark@intel.com>, <kok.howg.ewe@intel.com>,
        <margie.foster@intel.com>
Subject: Re: [PATCH net-next-2.6 8/17 v2] can: EG20T PCH: Change Copyright and module description
Date: Tue, 7 Dec 2010 18:50:37 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In case single destination address is OK, but in case multiple address is 
> set,
> I can see the following error.
> Relay access denied

The above was not true.
It seems in case destination mail domain is external, (except 
"@okisemi.com"),
this error is occurred.
In fact, in case multiple address with internal domain,
it is success to send patch.

Our smtp server may have restriction of something.

It seems I must use mailer "thunderbird" again.

Thanks,

/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_
Tomoya Morinaga
OKI SEMICONDUCTOR CO., LTD. 

