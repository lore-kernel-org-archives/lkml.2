Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089Ab0LNCQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 21:16:10 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:6790 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758901Ab0LNCQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 21:16:08 -0500
Message-ID: <98ED21118B7A4639B9AB0B8FFE323179@hacdom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "David Miller" <davem@davemloft.net>
Cc: <wg@grandegger.com>, <socketcan-core@lists.berlios.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1292221467-8039-18-git-send-email-tomoya-linux@dsn.okisemi.com><1292221467-8039-19-git-send-email-tomoya-linux@dsn.okisemi.com><1292221467-8039-20-git-send-email-tomoya-linux@dsn.okisemi.com> <20101213.122826.27813399.davem@davemloft.net>
Subject: Re: [PATCH net-next-2.6 v9 20/20] pch_can: Replace netif_rx to netif_receive_skb
Date: Tue, 14 Dec 2010 11:16:04 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thank you for your acceptance.

> Hi Marc and Wolfgang
Until now, thank you for your much help!

---
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

----- Original Message ----- 
From: "David Miller" <davem@davemloft.net>
To: <tomoya-linux@dsn.okisemi.com>
Cc: <wg@grandegger.com>; <w.sang@pengutronix.de>; <chripell@fsfe.org>; 
<21cnbao@gmail.com>; <sameo@linux.intel.com>; 
<socketcan-core@lists.berlios.de>; <netdev@vger.kernel.org>; 
<linux-kernel@vger.kernel.org>; <qi.wang@intel.com>; 
<yong.y.wang@intel.com>; <andrew.chih.howe.khor@intel.com>; 
<joel.clark@intel.com>; <kok.howg.ewe@intel.com>; <margie.foster@intel.com>
Sent: Tuesday, December 14, 2010 5:28 AM
Subject: Re: [PATCH net-next-2.6 v9 20/20] pch_can: Replace netif_rx to 
netif_receive_skb


> From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> Date: Mon, 13 Dec 2010 15:24:26 +0900
>
>> Since this driver is implemented as NAPI,
>> netif_receive_skb must be used not netif_rx.
>>
>> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
>> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
>
> Applied.
> 

