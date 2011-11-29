Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1K2Ley (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:34:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54108 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020Ab1K2Lex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:34:53 -0500
Date: Tue, 29 Nov 2011 11:34:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        drivers@analog.com, device-drivers-devel@blackfin.uclinux.org
Subject: Re: [PATCH 5/7] ASOC: AD193X: Add sysclk DAPM supply
Message-ID: <20111129113445.GG2851@opensource.wolfsonmicro.com>
References: <1322497692-27868-1-git-send-email-lars@metafoo.de>
 <1322497692-27868-5-git-send-email-lars@metafoo.de>
 <CAMjpGUcX9CsctL5Kd93R1ORv1D3Nx=iddQBSHKzMFvdhCS2NFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMjpGUcX9CsctL5Kd93R1ORv1D3Nx=iddQBSHKzMFvdhCS2NFg@mail.gmail.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 12:24:27AM -0500, Mike Frysinger wrote:
> nitpick: you've got a variety of subjects:

Mike, *please* include some context in your replies.

> ASoC: AD193X: ...
> ASOC: AD193X: ...
> ASoC: ad193x: ...

> be nice if it were consistent as it makes reading short logs easier ...

I actually fixed this up when I was applying them but yes this is
better.
