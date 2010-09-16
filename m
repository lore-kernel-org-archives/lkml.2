Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab0IPIwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 04:52:20 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:37967 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752422Ab0IPIvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 04:51:55 -0400
Message-ID: <002601cb557c$69292180$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: <arjan@linux.intel.com>, "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        <yong.y.wang@intel.com>, <gregkh@suse.de>, <qi.wang@intel.com>,
        <andrew.chih.howe.khor@intel.com>, <meego-dev@meego.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <socketcan-core@lists.berlios.de>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Barry Song" <21cnbao@gmail.com>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Wolfgang Grandegger" <wg@grandegger.com>
References: <4C8E1773.9090000@dsn.okisemi.com> <4C8E3FDE.2000002@pengutronix.de>
Subject: Re: [MeeGo-Dev][PATCH v2] Topcliff: Update PCH_CAN driver to 2.6.35
Date: Thu, 16 Sep 2010 17:51:45 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

> - Please remove rx-filter handling from the driver completely, simply
>   receive every can frame

This rx-filter function is for Topcliff's CAN HW function.
This function is important.
Could you tell us the reason why should we remove filter function ?

Thanks, Ohtake(OKISemi)

----- Original Message ----- 
From: "Marc Kleine-Budde" <mkl@pengutronix.de>
To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
Cc: "Wolfgang Grandegger" <wg@grandegger.com>; "David S. Miller" <davem@davemloft.net>; "Wolfram Sang"
<w.sang@pengutronix.de>; "Christian Pellegrin" <chripell@fsfe.org>; "Barry Song" <21cnbao@gmail.com>; "Samuel Ortiz"
<sameo@linux.intel.com>; <socketcan-core@lists.berlios.de>; <netdev@vger.kernel.org>; <linux-kernel@vger.kernel.org>;
<meego-dev@meego.com>; <andrew.chih.howe.khor@intel.com>; <qi.wang@intel.com>; <gregkh@suse.de>;
<yong.y.wang@intel.com>; "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>; <arjan@linux.intel.com>
Sent: Tuesday, September 14, 2010 12:14 AM
Subject: Re: [MeeGo-Dev][PATCH v2] Topcliff: Update PCH_CAN driver to 2.6.35



