Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab0FPH6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 03:58:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34294 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753718Ab0FPH6o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 03:58:44 -0400
Subject: Re: [PATCH v2] soc/sh: Fix I2C dependency for SND_FSI_AK4642 and SND_FSI_DA7210
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20100616074947.GC29614@linux-sh.org> (sfid-20100616_085006_460441_D8011665)
Date: Wed, 16 Jun 2010 08:58:41 +0100
Cc: Peter Huewe <PeterHuewe@gmx.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-sh@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>,
       Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B480F429-3819-4086-8576-F0A1B0FC093C@opensource.wolfsonmicro.com>
References: <201006141739.42346.PeterHuewe@gmx.de> <201006151649.07554.PeterHuewe@gmx.de> <20100615151913.GJ14510@rakim.wolfsonmicro.main> <201006151738.56143.PeterHuewe@gmx.de> <20100616035440.GA29614@linux-sh.org> <250A6DE6-BB14-42F7-9500-A479C8FCA9B3@opensource.wolfsonmicro.com> <20100616074947.GC29614@linux-sh.org> (sfid-20100616_085006_460441_D8011665)
To: Paul Mundt <lethal@linux-sh.org>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 Jun 2010, at 08:49, Paul Mundt wrote:
> On Wed, Jun 16, 2010 at 08:43:33AM +0100, Mark Brown wrote:

>> Since these are board specific drivers they know which I2C controller they are
>> hooked up to and so can usefully depend on a specific controller - without the
>> correct controller driver they will not function.

> I don't really mind one way or the other. Having it depend on the
> controller is fine, but it's not really much of a stretch to expect it to
> show up on other boards with other controllers as well.

This is the driver for the board itself and its wiring - it's not a chip driver, it's
the driver that says how the chips on a given board are connected. For new
boards I'd expect you'd end up with a new driver.