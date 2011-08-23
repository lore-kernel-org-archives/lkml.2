Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1HWQqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:46:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:39845 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab1HWQqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:46:32 -0400
Date: Tue, 23 Aug 2011 18:46:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Walmsley <paul@pwsan.com>,
        linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>, mporter@ti.com,
        Kevin Hilman <khilman@ti.com>, "Govindraj.R" <govindraj.raja@ti.com>
Subject: Re: [PATCH] tty: omap-serial: fix boot hang by converting to use a
 threaded IRQ handler (was Re: [PATCH] irq: always set IRQF_ONESHOT if no
 primary handler is specified)
In-Reply-To: <CA+55aFyFzzd2GBbwFYrXMK353UE4tdrdZ5Lt8=qEwaaMJvStnA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1108231844140.2807@ionos>
References: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de> <C5991460-2092-4E65-99EE-091F8DAA0AC3@gmail.com> <4E4D4A5F.202@linutronix.de> <20110818213418.GA20509@legolas.emea.dhcp.ti.com> <alpine.DEB.2.00.1108221742130.10315@utopia.booyaka.com>
 <alpine.DEB.2.00.1108222306300.28226@utopia.booyaka.com> <20110823095711.058d9cf4@lxorguk.ukuu.org.uk> <CA+55aFyFzzd2GBbwFYrXMK353UE4tdrdZ5Lt8=qEwaaMJvStnA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Tue, 23 Aug 2011, Linus Torvalds wrote:
> but the "there is no difference for others" seems to be total crap,
> exactly because it results in this IRQF mismatch.
> 
> So I think that commit should just be reverted. Thomas?

Yes. I missed that detail when I applied that patch. Reverting it
seems to be the only sensible solution.

Thanks,

	tglx
