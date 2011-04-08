Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1DHGQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 02:16:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53592 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752624Ab1DHGQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 02:16:32 -0400
Date: Fri, 8 Apr 2011 07:16:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: linux-next: manual merge of the sound tree with Linus' tree
Message-ID: <20110408061630.GB21700@opensource.wolfsonmicro.com>
References: <20110408143825.e15b444a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110408143825.e15b444a.sfr@canb.auug.org.au>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 02:38:25PM +1000, Stephen Rothwell wrote:

> Today's linux-next merge of the sound tree got a conflict in
> sound/soc/codecs/wm8994.c between commit 25985edcedea ("Fix common
> misspellings") from Linus' tree and commit f701a2e594e6 ("ASoC: Factor
> WM8958 DSP2 handling into separate file") from the sound tree.

> The latter moved the code changed by the former into another file.  I did
> not bother fixing the spelling errors there.

I guess I'll fix this by merging up next time there's a -rc.  Not sure
why such patches aren't getting done against -next, though.
