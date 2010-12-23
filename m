Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab0LWUlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 15:41:23 -0500
Received: from lechat.rtp-net.org ([88.191.19.38]:42888 "EHLO
	lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0LWUlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 15:41:21 -0500
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, liu.y.victor@gmail.com,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, B02280@freescale.com
Subject: Re: [PATCH v2] i.MX51 Framebuffer support
Organization: RtpNet
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
	<87bp4eb5r5.fsf@lechat.rtp-net.org>
	<87ipymun54.fsf@macbook.be.48ers.dk>
Date: Thu, 23 Dec 2010 21:45:23 +0100
In-Reply-To: <87ipymun54.fsf@macbook.be.48ers.dk> (Peter Korsgaard's message
	of "Wed, 22 Dec 2010 11:17:59 +0100")
Message-ID: <87wrn09q1o.fsf@lechat.rtp-net.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Korsgaard <jacmet@sunsite.dk> writes:
Hi,

>>>>>> "Arnaud" == Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org> writes:
>
>  Arnaud> Sascha Hauer <s.hauer@pengutronix.de> writes:
>  Arnaud> Hi,
>
>  >> The following series adds i.MX51 framebuffer support based on the
>  >> IPUv3. It is not perfect but I decided it is good enough to open it
>  >> for a wider audience and collect first reviews. I tested this on a
>  >> babbage board using both outputs (VGA/DVI) with different
>  >> resolutions up to 1680x1050 and different colour depths.  I also
>  >> tested it on one custom board using a fixed display setting.
>
>  Arnaud> After adding code to my efika sb machine file and your patchset, I've
>  Arnaud> seen the light. Err, no. It was a penguin and a login prompt.  I guess
>  Arnaud> it means your patchset is working here.
>
> Cool. Care to submit that machine file support?

Yes, I will (of course) but ... I'd like to see the usb issues I found
fixed because they're the only way to get usb on the sb and without usb,
you have no network, no keyboard, no way to connect any external device,
which makes the sb pretty useless. In the mean time, you can use my
patchset once I've added the fb support in it.

Arnaud
