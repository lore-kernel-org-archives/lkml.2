Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab0LWLua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:50:30 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36063 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab0LWLu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:50:28 -0500
Date: Thu, 23 Dec 2010 11:50:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Takashi Iwai'" <tiwai@suse.de>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassi.brar@samsung.com>
Subject: Re: linux-next: manual merge of the sound tree with the s5p tree
Message-ID: <20101223115024.GA28928@sirena.org.uk>
References: <20101223115339.1ce18216.sfr@canb.auug.org.au> <003f01cba28c$872214f0$95663ed0$%kim@samsung.com> <s5hk4j0n43g.wl%tiwai@suse.de> <004001cba292$3827d2d0$a8777870$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004001cba292$3827d2d0$a8777870$%kim@samsung.com>
X-Cookie: Oh, so there you are!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 08:11:56PM +0900, Kukjin Kim wrote:
> Takashi Iwai wrote:

> > > Anyway I need above commits from sound-2.6.git in my tree...
> > > so how method is better to me instead of cherry-pick it?

> > You can merge topic/asoc branch of sound git tree.
> > This brach contains the all necessary commits for ASoC and is almost
> > never rebased.

> But I can't merge it because there is no 'topic/asoc' branch in
> sound-2.6.git.
> (git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git)

> Is there another repository?

topic/asoc is in Takashi's tree and is equivalent to my for-next branch,
it usually lags it by only a small amount.  Takashi's tree is at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git

> And should I merge it in my tree even though don't need all of ASoC commits
> :-( ?
> I'm not sure how many commits are in there...

There's a lot of stuff in there but it shouldn't do any harm to
pre-merge (and we're almost at the merge window anyway).
