Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2KSQny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 11:43:54 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:40719 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab2KSQnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:43:53 -0500
Date: Mon, 19 Nov 2012 17:43:39 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 1/2] clk: mvebu: armada 370/XP add clock gating control
 provider for DT
Message-ID: <20121119174339.0ea43e5e@skate>
In-Reply-To: <20121119155856.GL10259@lunn.ch>
References: <1353014906-31566-6-git-send-email-andrew@lunn.ch>
	<1353088920-17458-1-git-send-email-gregory.clement@free-electrons.com>
	<1353088920-17458-2-git-send-email-gregory.clement@free-electrons.com>
	<20121117082602.GF24569@lunn.ch>
	<50A75BB4.4070003@free-electrons.com>
	<20121117135435.GA13479@lunn.ch>
	<20121119164611.2e754b64@skate>
	<20121119155856.GL10259@lunn.ch>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew Lunn,

On Mon, 19 Nov 2012 16:58:56 +0100, Andrew Lunn wrote:

> I don't think we are taking about the same clock. I mean the gate
> clock:
> 
> 28   ddr     DDR Cntrl
> 
> not the core clock.

Right, after discussion with Gregory, I found out my misunderstanding.
I'm looking now as to how this clock affects the system behavior. I
indeed see this clock ->disable() hook being called, but it doesn't
seem to cause any sort of problem on the system. It still works nicely.
So not sure this clock is actually doing something, or at least maybe
not what we think it does.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
