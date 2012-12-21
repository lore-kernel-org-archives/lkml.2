Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab2LUOwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 09:52:30 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:55170 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab2LUOwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:52:23 -0500
X-Auth-Info: 1+ZcIgaPgRox4zOOc6wt4r/uLDWVE6AxTE0tczswSqk=
From: Marek Vasut <marex@denx.de>
To: Torben Hohn <torbenh@linutronix.de>
Subject: Re: Improve timer Resolution on imx28
Date: Fri, 21 Dec 2012 15:52:17 +0100
User-Agent: KMail/1.13.7 (Linux/3.6-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <1356098776-10498-1-git-send-email-torbenh@linutronix.de>
In-Reply-To: <1356098776-10498-1-git-send-email-torbenh@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201212211552.17744.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Torben Hohn,

> Hi,
> 
> this Series increases the timer frequency and decreases min_delta_ns.
> I saw pretty high max latencies with cyclictest: ~600us.
> 
> The cause was the min_delta_ns value of 0xf 32kHz clockcycles.
> But with the 32kHz Clock, the period is still around 30us.
> So we just increase the clock freqeuncy driving the timers
> here.

Thanks for the set. Just a really quick question -- won't this under no 
circumstance cause interrupt storm?

Best regards,
Marek Vasut
