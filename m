Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab1BUX33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:29:29 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59400 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1BUX31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:29:27 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH 2/2] clk: Generic support for fixed-rate clocks
Date: Tue, 22 Feb 2011 07:29:11 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
References: <1298256658.862488.956979497586.2.gpush@pororo> <4D62C237.1020803@bluewatersys.com>
In-Reply-To: <4D62C237.1020803@bluewatersys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102220729.13708.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

> If we never need to dynamically create fixed clocks (which seems
> unlikely) then rate can be const.

There's been a few cases where I've needed to set the rate of a fixed clock 
during boot - for example when a clock rate varies between boards, it may be 
defined in a platform-wide file, but have the rate modified early (ie, 
clk_foo.rate = 32678) in a board file.

Also, if we're parsing clocks from the device tree (or any other discovery 
mechanism), we'll need to modify rate.

Cheers,


Jeremy
