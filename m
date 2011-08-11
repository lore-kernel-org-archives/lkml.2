Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab1HKFKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 01:10:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38095 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750796Ab1HKFKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 01:10:15 -0400
Date: Thu, 11 Aug 2011 13:06:23 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20110811035552.GB15906@opensource.wolfsonmicro.com>
References: <20110811131129.f0d6226079d86e8f4a5ae920@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110811131129.f0d6226079d86e8f4a5ae920@canb.auug.org.au>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 01:11:29PM +1000, Stephen Rothwell wrote:

> sound/soc/codecs/snd-soc-wm8750: struct spi_device_id is 40 bytes.  The last of 2 is:
> 0x77 0x6d 0x38 0x39 0x38 0x37 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 
> FATAL: sound/soc/codecs/snd-soc-wm8750: struct spi_device_id is not terminated with a NULL entry!

> Caused by commit 40045a85df0e ("ASoC: Fix SPI driver binding for WM8987").

No it wasn't, it was there already.  Anyway, should be fixed now.

Do you have any idea what you're doing to turn on this detection?  It
really shouldn't be something that's specific to the x86 build but
there's nothing obvious I can see that does it.

Out of interest you used to carry reverts for commits when you'd
identified them but that seems not to happen any more?
