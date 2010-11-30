Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab0K3XrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 18:47:10 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:11983 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457Ab0K3XrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 18:47:08 -0500
Message-ID: <001101cb90e8$e60c76a0$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: "Wolfgang Grandegger" <wg@grandegger.com>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "Barry Song" <21cnbao@gmail.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        <andrew.chih.howe.khor@intel.com>, <qi.wang@intel.com>,
        <margie.foster@intel.com>, <yong.y.wang@intel.com>,
        <kok.howg.ewe@intel.com>, <joel.clark@intel.com>
References: <4CF47BAA.2090209@dsn.okisemi.com> <4CF4E897.7090702@pengutronix.de>
Subject: Re: [PATCH net-next-2.6 v6 06/20] can: EG20T PCH: Fix endianness issue
Date: Wed, 1 Dec 2010 08:47:04 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
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

On Tuesday, November 30, 2010 9:05 PM, Marc Kleine-Budde wrote:
> The patch does more than fixing the endianess issue. Please split non
> endianess related changes into seperate patch.
I will split the patch like your indication.

Do you have any comments for v6 other patches ?

Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.
