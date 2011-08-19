Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab1HSHZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 03:25:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:44224 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1HSHZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 03:25:37 -0400
Message-ID: <4E4E0FEF.3010006@linutronix.de>
Date: Fri, 19 Aug 2011 09:25:35 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: balbi@ti.com
CC: Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        mporter@ti.com
Subject: Re: [PATCH] irq: always set IRQF_ONESHOT if no primary handler is
 specified
References: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de> <C5991460-2092-4E65-99EE-091F8DAA0AC3@gmail.com> <4E4D4A5F.202@linutronix.de> <20110818213418.GA20509@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110818213418.GA20509@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi wrote:
>> Pantelis Antoniou wrote:
>>> Let me report that with this change Beagle board fails to boot,
>>> hangs right on rootfs mount.
>> Can you provide some more information about the kind of the failure and
>> used drivers?
>>
>>> Users of BB should revert this until the offending driver(s) are fixed.
>> Which is the offending driver?
> 
> I would guess it's the lack of threaded IRQ conversion on the
> twl4030 driver. I have converted it but noone actually picked the series
> [1].

This makes no sense. If you don't use threaded handlers that means
you specify a primary handler and therefore the patch does not change a
thing for you.

> http://marc.info/?i=1309427470-605-1-git-send-email-balbi@ti.com

Sebastian
