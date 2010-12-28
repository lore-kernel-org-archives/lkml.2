Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab0L1PkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 10:40:03 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60389 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab0L1Pj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 10:39:57 -0500
Date: Tue, 28 Dec 2010 15:39:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Russell King'" <rmk@arm.linux.org.uk>, "'Takashi Iwai'" <tiwai@suse.de>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassi.brar@samsung.com>
Subject: Re: linux-next: manual merge of the sound tree with the s5p tree
Message-ID: <20101228153948.GB14860@sirena.org.uk>
References: <20101223115339.1ce18216.sfr@canb.auug.org.au> <003f01cba28c$872214f0$95663ed0$%kim@samsung.com> <s5hk4j0n43g.wl%tiwai@suse.de> <004001cba292$3827d2d0$a8777870$%kim@samsung.com> <s5hvd2ku49r.wl%tiwai@suse.de> <004101cba294$8639de30$92ad9a90$%kim@samsung.com> <s5h7hf0tvct.wl%tiwai@suse.de> <008f01cba30a$72f5c160$58e14420$%kim@samsung.com> <20101224082736.GA31540@flint.arm.linux.org.uk> <018b01cba636$6c3a8390$44af8ab0$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <018b01cba636$6c3a8390$44af8ab0$%kim@samsung.com>
X-Cookie: George Orwell was an optimist.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 11:24:49AM +0900, Kukjin Kim wrote:

> Takashi, as Russell's first option, could you please make some branch which
> includes following to me?

Please keep myself and Liam in the CC on all ASoC discussion.

> Of course, I know you need rebase you tree for it...so sorry for bothering.

This isn't going to help as it will just introduce the same duplicate
commits issue into the sound tree.  I'm still not clear what the
affected commits actually are but given that Stephen's original report
indicated that the ASoC changes are subsets of your changes would it not
make sense to just drop the relevant commits from your tree (which seems
to be rebased often, unlike the sound tree which doesn't rebase)?

Another option is to do a second round of merges after both sound and
ALSA trees with whatever the dependant commits are.
