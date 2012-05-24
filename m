Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab2EXKHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:07:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37458 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753381Ab2EXKHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:07:45 -0400
Date: Thu, 24 May 2012 11:07:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, lars@metafoo.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] sound/soc/lapis: add platform driver for ML7213
Message-ID: <20120524100742.GH5361@opensource.wolfsonmicro.com>
References: <1331275160-31757-1-git-send-email-tomoya.rohm@gmail.com>
 <1332158459-14880-1-git-send-email-tomoya.rohm@gmail.com>
 <20120321160913.GF3226@opensource.wolfsonmicro.com>
 <CANKRQnjoGN=uvej8B1BxPHAx7NQtOORD9yJRPUc134DrVmPzNg@mail.gmail.com>
 <20120326154009.GA17506@sirena.org.uk>
 <CANKRQnhn=ALR0ucv5gnvwnxwxBQX4ajm9Jo5qC0fL-EFjDdoZg@mail.gmail.com>
 <20120523093857.GC4085@opensource.wolfsonmicro.com>
 <CANKRQnhNWC2F6zKgBMJY7HnipJbA5p-=6Lz4uGZqBKNQ688Z3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQnhNWC2F6zKgBMJY7HnipJbA5p-=6Lz4uGZqBKNQ688Z3w@mail.gmail.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 08:46:03AM +0900, Tomoya MORINAGA wrote:
> On Wed, May 23, 2012 at 6:41 PM, Mark Brown

> > Nobody seems to be working on it as far as I can tell, I've certainly
> > not seen any patches.

> If so, could you accept current platform/machine driver ?

Ideally what would be happening here is that you or other people who
have such systems would be working to add the required support to the
core code, there's clearly a need for common code here as there are a
number of different systems that don't have cyclic DMA and it wouldn't
be great to end up with duplicated code.

Is there some great difficulty in factoring out the support for
non-cyclic audio DMA on dmaengine - it seems like if there is we must
have a serious problem in dmaengine which we should fix?  If there is a
substantial difficulty then that's different but it doesn't feel like
we've tried doing common code yet, if there's problems doing that I'd
like to understand what they are before we jump ahead of ourselves.
