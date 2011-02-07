Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1BGTKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:10:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60687 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab1BGTKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:10:30 -0500
Subject: Re: [PATCH] ASoC: codecs: wm8753: Fix DAI mode switching
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <1296983051-3105-1-git-send-email-lars@metafoo.de>
References: <1296983051-3105-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 19:10:25 +0000
Message-ID: <1297105825.3331.353.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-06 at 10:04 +0100, Lars-Peter Clausen wrote:
> The wm8753 codec supports switching between different DAI modes.
> The current drivers tries to implement this by changing the DAI driver at
> runtime. But to properly work this would require support from the ASoC core.
> 
> So this patch takes a different approch on how the DAI mode switching is
> implemented.
> 
> The only difference, from a driver point of view, between the different DAI modes
> is how to program the DAI format to the hardware. So what this patch is, it
> stores the current format for each DAI in the drivers private struct and when
> the DAI mode is changed the format gets simply reprogrammed according to the
> new DAI mode.
> 
> Futhermore this patch restricts the changing of the DAI format to when the
> codec is inactive.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

