Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab0JKMgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 08:36:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33730 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754275Ab0JKMgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 08:36:12 -0400
Date: Mon, 11 Oct 2010 13:36:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: wm8804: fix error handling code
Message-ID: <20101011123609.GL9231@rakim.wolfsonmicro.main>
References: <1286731745-18169-1-git-send-email-segooon@gmail.com>
 <20101011120014.GJ9231@rakim.wolfsonmicro.main>
 <20101011121555.GA32652@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101011121555.GA32652@albatros>
X-Cookie: Help a swallow land at Capistrano.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 04:15:55PM +0400, Vasiliy Kulikov wrote:
> On Mon, Oct 11, 2010 at 13:00 +0100, Mark Brown wrote:

> > ...it's not clear to me that this change is an improvement - it'll make
> > the driver more fragile in the face of errors, I don't see a benefit in
> > refusing to register the variant for one bus if the other fails?

> I tried to implement your variant with depca driver in past, but it was
> rejected by David Miller:
> http://lists.openwall.net/netdev/2010/07/12/9

I disagree with David here, and in any case if you're going to make a
style change like this they really ought to be applied over all drivers
rather than just a few individual ones.
