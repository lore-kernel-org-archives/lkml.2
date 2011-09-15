Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365Ab1IOLxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 07:53:46 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:58628 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933075Ab1IOLxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 07:53:45 -0400
Message-ID: <4E71E720.7040008@metafoo.de>
Date: Thu, 15 Sep 2011 13:53:04 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Russell King <rmk+alsa@arm.linux.org.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>, Harald Welte <laforge@openezx.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [linux-next] ASoC: sound/soc/samsung/neo1973_wm8753.c build failure
References: <1315991893.17271.2.camel@phoenix> <20110914191917.GA30518@flint.arm.linux.org.uk> <20110914232808.GC2953@opensource.wolfsonmicro.com> <20110914233838.GB22946@flint.arm.linux.org.uk> <20110915094640.GA7988@opensource.wolfsonmicro.com> <20110915110056.GA32615@flint.arm.linux.org.uk>
In-Reply-To: <20110915110056.GA32615@flint.arm.linux.org.uk>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2011 01:00 PM, Russell King wrote:
> [...]
> We now have a sane policy: entries which aren't fully up to date are
> automatically dropped.  Entries for which there is no platform support
> file merged within 12 months of the entries last edit are dropped also
> automatically dropped.

Partly unrelated, but what about these platforms which can be fully described
with DT and don't need a platform file?

> [...]
> Lastly, GTA01 board support was added to the ALSA stuff in 2008 without
> the main platform support in arch/arm - so it can't be usefully used.
> It's been three years since that was done and still there is no sign of
> the main platform support appearing.  It's been five years since the
> entry was created in the machine database.
> 
> Face it, GTA01 is dead as far as mainline is concerned.
> 
> If it's not dead then it needs sorting out.  Either way there's two
> valid states:  1. fully merged, or 2. none of it is merged.
> There's no real half-way house state - certainly not one which should
> persist for three years.  (It would be reasonable for maybe a couple
> of kernel releases but more than that is becoming very much a joke.)

The code for GTA01 is out there and could be merged into mainline, but I think
it would be dead code since there doesn't seem to be really any interest in the
device anymore.

So just get rid of the gta01 portions of the neo1973_wm8753 driver. If GTA01
support ever gets merged we can still revert the removal.

- Lars
