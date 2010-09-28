Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab0I1E57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 00:57:59 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:2007 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041Ab0I1E56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 00:57:58 -0400
Message-ID: <002801cb5ec9$b7936a00$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Mike Frysinger" <vapier@gentoo.org>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Alek Du" <alek.du@intel.com>, <richard.rojfors@mocean-labs.com>,
        <meego-dev@meego.com>,
        "ML linux-kernel" <linux-kernel@vger.kernel.org>,
        "Qi" <qi.wang@intel.com>, <andrew.chih.howe.khor@intel.com>,
        <gregkh@suse.de>, "Yong Y" <yong.y.wang@intel.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        <joel.clark@intel.com>, <margie.foster@intel.com>,
        <kok.howg.ewe@intel.com>
References: <4C80D3C8.9020204@dsn.okisemi.com> <20100903134827.GA7614@rakim.wolfsonmicro.main> <000301cb5ebc$35ad8d20$66f8800a@maildom.okisemi.com> <201009272338.23762.vapier@gentoo.org>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_GPIO driver to 2.6.35
Date: Tue, 28 Sep 2010 13:57:50 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike and Mark,

Thanks for your help.

But, I've got a bit of problem again.
I have modified for GPIO standard I/F referring other accepted GPIO driver.

According to Documentation/gpio.txt,
I tried to create GPIO node like below.

[root@localhost gpio]# ls
export  gpiochip244  unexport
[root@localhost gpio]# echo 1 > export
bash: echo: write error: Invalid argument
[root@localhost gpio]#

But it fails.

Could you teach me the reason/cause why?

Thanks, Ohtake(OKISemi)



