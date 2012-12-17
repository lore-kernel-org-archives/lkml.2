Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab2LQJfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 04:35:23 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:47229 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397Ab2LQJfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 04:35:21 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAKrlzlBthYXF/2dsb2JhbABFhju3dhdzgh4BAQUjMyMQCxgCAiYCAhQlJIgqpz6SFYEiizuDMDJhA5YJkEmCdA
Date: Mon, 17 Dec 2012 10:35:16 +0100
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] tx/rx LED trigger support
Message-ID: <20121217093516.GB17341@vandijck-laurijssen.be>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@gmail.com>,
	linux-kernel@vger.kernel.org
References: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio,

Nice work to repackage this :-) !

Kurt

On Sun, Dec 16, 2012 at 12:08:24PM +0100, Fabio Baltieri wrote:
> Hi all,
> 
> this is a resend of the patch series on tx/rx LEDs trigger.  The patch
> set was put on hold after the latest discussions on Kurt's rename patch
> due to a missing feature in the LED subsystem, which has been just
> merged in:
> 
> a8df7b1 leds: add led_trigger_rename function
> 
> So, as months passed since the latest developments, I'm reposting the
> whole set, rebased on current mainline.  The first patches are the same
> that were merged in can-next/led-trigger, but there was some (trivial)
> conflict in the rebase.
> 
> As for the test, I've tried the patch on the current mainline kernel
> with my custom usb-can interface.  For the drivers, I don't have any
> SoC-enabled board anymore, so they have only been compile tested.
> 
> Cheers,
> Fabio
> 
> 
> Fabio Baltieri (7):
>   can: add tx/rx LED trigger support
>   can: flexcan: add LED trigger support
>   can: at91_can: add LED trigger support
>   can: ti_hecc: add LED trigger support
>   can: c_can: add LED trigger support
>   can: mcp251x: add LED trigger support
>   can: sja1000: add LED trigger support
> 
> Kurt Van Dijck (2):
>   can: export a safe netdev_priv wrapper for candev
>   can: rename LED trigger name on netdev renames
> 
>  drivers/net/can/Kconfig           |  12 ++++
>  drivers/net/can/Makefile          |   2 +
>  drivers/net/can/at91_can.c        |  10 +++
>  drivers/net/can/c_can/c_can.c     |  10 +++
>  drivers/net/can/dev.c             |  18 ++++++
>  drivers/net/can/flexcan.c         |  11 ++++
>  drivers/net/can/led.c             | 129 ++++++++++++++++++++++++++++++++++++++
>  drivers/net/can/mcp251x.c         |  23 +++++--
>  drivers/net/can/sja1000/sja1000.c |  17 ++++-
>  drivers/net/can/ti_hecc.c         |  10 +++
>  include/linux/can/dev.h           |  11 ++++
>  include/linux/can/led.h           |  51 +++++++++++++++
>  12 files changed, 299 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/net/can/led.c
>  create mode 100644 include/linux/can/led.h
> 
> -- 
> 1.7.12.1
> 
