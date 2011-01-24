Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab1AXEem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 23:34:42 -0500
Received: from www.tglx.de ([62.245.132.106]:43129 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab1AXEel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 23:34:41 -0500
Date: Mon, 24 Jan 2011 10:04:27 +0530
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: dilinger@queued.net
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [PATCH TIP 02/14] x86: Add device tree support
Message-ID: <20110124043427.GA20274@www.tglx.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de> <1295843342-1122-3-git-send-email-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1295843342-1122-3-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior | 2011-01-24 09:58:50 [+0530]:

>This patch adds minimal support for device tree support on x86. It will
>be passed to the kernel via setup_data which requires atleast boot
>protocol 2.09.
>Memory size, restricted memory regions, boot arguments are gathered the
>traditional way so things like cmd_line are just here to let the code
>compile.
>The current plan is use the device tree as an extension and to gather
>informations from it which can not be enumerated and have to be
>hardcoded otherwise. This includes things like
>- which devices are on this I2C/ SPI bus?
>- how are the interrupts wired to IO APIC?
>- where could my hpet be?
>

Andres, this patch moves some of the OF defines you added for OLPC from
irq.c to prom.c which requires CONFIG_X86_OF to be enabled. A later
patch changes irq_create_of_mapping() from returning intspec[0] to
actually doing something. Could you please check how of OLPC gets broken
and what we could do about it? :)

Sebastian
