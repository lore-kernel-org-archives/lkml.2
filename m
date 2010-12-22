Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab0LVHwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 02:52:53 -0500
Received: from lechat.rtp-net.org ([88.191.19.38]:41960 "EHLO
	lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab0LVHww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 02:52:52 -0500
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, liu.y.victor@gmail.com,
        B02280@freescale.com, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v2] i.MX51 Framebuffer support
Organization: RtpNet
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
Date: Wed, 22 Dec 2010 08:56:14 +0100
In-Reply-To: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
	(Sascha Hauer's message of "Mon, 20 Dec 2010 11:48:38 +0100")
Message-ID: <87bp4eb5r5.fsf@lechat.rtp-net.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sascha Hauer <s.hauer@pengutronix.de> writes:

Hi,

> The following series adds i.MX51 framebuffer support based on the IPUv3. It
> is not perfect but I decided it is good enough to open it for a wider audience
> and collect first reviews. I tested this on a babbage board using both outputs
> (VGA/DVI) with different resolutions up to 1680x1050 and different colour depths.
> I also tested it on one custom board using a fixed display setting.

After adding code to my efika sb machine file and your patchset, I've
seen the light. Err, no. It was a penguin and a login prompt.  I guess
it means your patchset is working here.

btw, would be nice to add some comments/docs about :
- the meaning of the fields of the imx_ipuv3_platform_data struct. it's
not clear
- same for .display field of the ipuv3_fb_platform_data

Arnaud
