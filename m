Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab1HRRWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:22:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:54834 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1HRRWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:22:42 -0400
Message-ID: <4E4D4A5F.202@linutronix.de>
Date: Thu, 18 Aug 2011 19:22:39 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Pantelis Antoniou <pantelis.antoniou@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        mporter@ti.com
Subject: Re: [PATCH] irq: always set IRQF_ONESHOT if no primary handler is
 specified
References: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de> <C5991460-2092-4E65-99EE-091F8DAA0AC3@gmail.com>
In-Reply-To: <C5991460-2092-4E65-99EE-091F8DAA0AC3@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pantelis Antoniou wrote:
> Hi there,
Hi,

> Let me report that with this change Beagle board fails to boot,
> hangs right on rootfs mount.

Can you provide some more information about the kind of the failure and
used drivers?

> Users of BB should revert this until the offending driver(s) are fixed.
Which is the offending driver?

> Regards
> 
> -- Pantelis

Sebastian
