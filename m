Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab0IWSij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 14:38:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51801 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756095Ab0IWSii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 14:38:38 -0400
Date: Thu, 23 Sep 2010 19:38:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
Subject: Re: [PATCH] ASoC: Add max98088 CODEC driver
Message-ID: <20100923183835.GC32112@rakim.wolfsonmicro.main>
References: <B2150E1E4418E1438554A300EA5040E40D469C1248@ITSVLEX06.it.maxim-ic.internal>
 <20100923120443.GF25663@rakim.wolfsonmicro.main>
 <B2150E1E4418E1438554A300EA5040E40D46E1BE7C@ITSVLEX06.it.maxim-ic.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40D46E1BE7C@ITSVLEX06.it.maxim-ic.internal>
X-Cookie: My NOSE is NUMB!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 10:56:38AM -0700, Peter Hsiang wrote:
> On Thu, Sep 23, 2010, Mark Brown wrote:

> > |   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git

> > Currently you should be looking at for-next or for-2.6.37, though the
> > branch names will change as kernel development moves forward.

> What is the git command line path/parameter for for-next or for-2.6.37?
> Something equivalent to...
> ....pub/scm/linux/kernel/git/next/linux-next.git 

That is the git path to the repository.  for-next and for-2.6.37 are
branches in that repository.

> Why do the files in git/broonie/sound-2.6.git look older than -next?
> For example, it's missing soc-cache.c, and the codec drivers there
> use the old I/O method.  Same drivers in -next are newer and use the soc-cache.

You're looking at the wrong branch, you need to look at one of the
branches mentioned above.  git branch -r to list remote branches.  I
can't remember what the default branch is but since it changes with
every release it's not always up to date.

Developing against -next is also OK, it contains everything in the above
tree (and then some).
