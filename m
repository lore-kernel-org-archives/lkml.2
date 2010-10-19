Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab0JSAJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:09:49 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:2049 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687Ab0JSAJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:09:48 -0400
Message-ID: <000c01cb6f21$f0a6ac90$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Wolfgang Grandegger" <wg@grandegger.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "Barry Song" <21cnbao@gmail.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        <socketcan-core@lists.berlios.de>,
        "ML netdev" <netdev@vger.kernel.org>,
        "ML linux-kernel" <linux-kernel@vger.kernel.org>,
        <andrew.chih.howe.khor@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        "Intel OTC" <joel.clark@intel.com>
References: <000b01cb6eb3$1afcfd60$66f8800a@maildom.okisemi.com> <4CBC29E6.3070601@grandegger.com>
Subject: Re: [MeeGo-Dev] can: How to set bitrate
Date: Tue, 19 Oct 2010 09:09:41 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 18, 2010 8:05 PM, Wolfgang Grandegger wrote:

> ~$ rpm -qf /usr/include/db_185.h
> db4-devel-4.7.25-13.fc12.i686
>
> Which means you need db4 devel to fully build iproute2.

Thank you for your information.

Using the following command,
"yum install db4*"
I could confirm building iproute2 is success and
set bitrate.

Thanks, Ohtake(OKISemi)


