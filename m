Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab1FJSDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:03:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46927 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757461Ab1FJSC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:02:59 -0400
Date: Fri, 10 Jun 2011 19:02:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [alsa-devel] [PATCH 2/3] ASoC: Blackfin: Add bf5xx-adau1701
 machine driver
Message-ID: <20110610180256.GQ26436@opensource.wolfsonmicro.com>
References: <1307726331-28618-1-git-send-email-lars@metafoo.de>
 <1307726331-28618-2-git-send-email-lars@metafoo.de>
 <20110610173004.GJ26441@sirena.org.uk>
 <4DF25959.9060603@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF25959.9060603@metafoo.de>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 07:50:17PM +0200, Lars-Peter Clausen wrote:
> On 06/10/2011 07:30 PM, Mark Brown wrote:

> > So, I keep on complaining about the way these drivers are just generic
> > to any random Blackfin plus CODEC combination rather than being board
> > specific.  It'd be good if we could improve this, even adding something
> > into the driver name to make it clear these are for the EVB would help.

> I think this is due, that the codecs them-self sit on an add-on board to the
> bf5xx eval boards.
> So you have two boards, the bf5xx eval board with has the codec eval board
> connected to it. That's why it it is kept so generic. You could connect the
> codec eval board to any of the bf5xx boards.

I'd be more happy with that if there were some indication in the code
that this was for the standard Blackfin EVBs rather than all systems
based on Blackfin.
