Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1BGV3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:29:13 -0500
Received: from claw.goop.org ([74.207.240.146]:35526 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab1BGV3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:29:11 -0500
Message-ID: <4D50641B.2090006@goop.org>
Date: Mon, 07 Feb 2011 13:28:59 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
References: <20110205200108.921707839@linutronix.de>
In-Reply-To: <20110205200108.921707839@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2011 12:08 PM, Thomas Gleixner wrote:
> the following series converts the interrupt chips of XEN to the new
> chip functions and the last patches replace the xen private resume
> hackery.
>
> The first two patches have no dependencies.
>
> The last two need the modification to the generic interrupt layer. I
> could either carry them through the genirq tree with your
> acked-tested-whatever-by or I provide you a branch to pull that change
> from. I need the genirq change local as it conflicts with other patches
> in the pipeline. Either way works fine.

Hi Thomas,

Thanks very much for looking at this.  IanC also has some patches to
clean up the Xen interrupt stuff to get rid of the local hacks, so I'll
let him work out how to reconcile the two sets of work (ah, I see he's
already replied).

[Read patches]

It doesn't look like there's any functional overlap at all, since his
patches are concerned with using the core irq allocator rather than a
private one, so that's OK.

Anyway, I'll let Ian do the ack.

    J
