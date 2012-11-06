Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab2KFRTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 12:19:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59739 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2KFRTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 12:19:42 -0500
Date: Tue, 6 Nov 2012 18:19:39 +0100
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Roland Stigge <stigge@antcom.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [PATCH] pwm: lpc32xx - Fix the PWM polarity
Message-ID: <20121106181939.61c50233@avionic-0020.adnet.avionic-design.de>
In-Reply-To: <CAAAP30HwBzYFpy942UyiQX2SkzV4naBbhwichp201bvfEm2mxA@mail.gmail.com>
References: <1352134125-22405-1-git-send-email-alban.bedel@avionic-design.de>
	<20121105210317.GA9930@avionic-0098.mockup.avionic-design.de>
	<5098DA10.3080002@antcom.de>
	<CAAAP30HwBzYFpy942UyiQX2SkzV4naBbhwichp201bvfEm2mxA@mail.gmail.com>
Organization: Avionic Design
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:JBuRmgRAuvsFi0unbX5jLpn37cAPkZhw3ydLidgwe23
 f4G/Pl3/FR9aW0kDKHXbtR6Hu0uvvIR5A+Rr3uJq/gnGXtiFWN
 fSU8YDEpr4omQUuA/yxpZEu/oJA9SrFPCLPRC7qlH4HGpDCHUo
 guClb4odL7HxquCsySqACjnlDtG69r3S3RGKKs+8D+NjHlouzM
 pisqOcqdaZkkjcbUDedHg5fM52TWJSkNqeGluDjVb+6A90a/Ii
 uZl6LX9WoVFMtYLs3fbCCaKBTBUZNXBMmD7XyjtuAuW6kfX+Ns
 XX0leMeiGjdk0Clk290hM64Shx8dbxIUJnVt3FFcPkSEJaTY6o
 rBaWock6L0naSb4xIb6MRlxnVXbzJU4UEvkQYW8SGx29uLGhP4
 oGjY76MUexT1H+CE94NyHHIBpOeRKIIaNk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2012 07:47:22 -0200
Alexandre Pereira da Silva <aletes.xgr@gmail.com> wrote:

> Can you test the 0 and 255 values on actual hardware and see the effective
> values?

0   ->   0%
1   ->  99%
128 ->  50%
255 ->   1%

So yes 0 mean 256.

> It may be handled as the RELOADV where 0 really means 256. If so, you can
> use the same logic I used originally on the frequency division.

I'll look at this and submit a new patch.

Alban
