Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab1FAMy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:54:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48810 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab1FAMy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:54:57 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 3/8] MFD: twl4030-audio: Rename platform data
Date: Wed, 1 Jun 2011 15:54:52 +0300
User-Agent: KMail/1.13.7 (Linux/2.6.39-gentoo; KDE/4.6.3; x86_64; ; )
CC: "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
References: <1306927051-8937-1-git-send-email-peter.ujfalusi@ti.com> <1306927051-8937-4-git-send-email-peter.ujfalusi@ti.com> <20110601120754.GC11352@atomide.com>
In-Reply-To: <20110601120754.GC11352@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-ID: <201106011554.53090.peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 June 2011 15:07:54 Tony Lindgren wrote:
> 
> Can you please take a look at creating arch/arm/mach-omap2/i2c-twl.c or
> something in common-board-devices.c to get rid of the cut and paste
> duplication in every board-*.c file?

Yes, it would make sense, since most of the board has similar configuration, 
and we have lots of duplicated code around.
 
> Maybe you could have a generic twl_init function that allows overriding
> things like keypad with board specific configuration?

We might need also support for overriding other configurations 
(audio/codec/vibra for sure needs that).

I'll take a look, but I think it is not going to be part of v2 of this series.

-- 
Péter
