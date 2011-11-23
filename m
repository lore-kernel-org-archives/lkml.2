Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab1KWLKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:10:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39049 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671Ab1KWLKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:10:23 -0500
Date: Wed, 23 Nov 2011 11:10:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound: drop support for PlayPaq with WM8510
Message-ID: <20111123111021.GF21073@opensource.wolfsonmicro.com>
References: <1322041150.1753.25.camel@x61.thuisdomein>
 <20111123102933.GI4332@opensource.wolfsonmicro.com>
 <1322046346.1753.59.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322046346.1753.59.camel@x61.thuisdomein>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 12:05:46PM +0100, Paul Bolle wrote:
> On Wed, 2011-11-23 at 10:29 +0000, Mark Brown wrote:
> > Applied, thanks.  Please do always use subject lines which match the
> > subsystem you're submitting against.

> I'll try to do that. But I'm not so familiar with the sound system. What
> actually is the subsystem I should have used here?

ASoC for this stuff, ALSA in general.  The easiest way to do this is to
run 'git log' on the files you're changing and see what all the other
commits are using.
