Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab2KXSKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 13:10:40 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:39670 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab2KXSKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 13:10:39 -0500
Date: Sat, 24 Nov 2012 19:10:24 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] ARM: Dove: Convert to DT GPIO and pinctrl
Message-ID: <20121124191024.4b5d5b4c@skate>
In-Reply-To: <20121124150004.GQ15800@titan.lakedaemon.net>
References: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1353317996-20841-4-git-send-email-sebastian.hesselbarth@gmail.com>
	<20121124023942.GO15800@titan.lakedaemon.net>
	<20121124080240.3f600e89@skate>
	<20121124150004.GQ15800@titan.lakedaemon.net>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jason Cooper,

On Sat, 24 Nov 2012 10:00:04 -0500, Jason Cooper wrote:

> Yes, so that's what I thought happened.  This would have made orion/dt
> depend upon mvebu/everything.  It already had two other dependencies.
> Not ideal.
> 
> The good thing is, the build is not broken.  Once v3.8-rc1 drops with
> all of our stuff merged, I'll post a fixup patch adding this back in.

It unfortunately means that Dove will be basically unbootable in
3.8-rc1, as the driver will not be clk_get()ing its gatable clock, and
the clock driver will disable it. Maybe we can just live with it, I
don't know.

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
