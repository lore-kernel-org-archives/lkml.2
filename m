Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab2AID10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 22:27:26 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44590 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab2AID1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 22:27:25 -0500
Date: Mon, 9 Jan 2012 03:10:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the sound-asoc tree
Message-ID: <20120109031000.GB20043@sirena.org.uk>
References: <20120109125531.dbcac0481adb6376fb7e9ca1@canb.auug.org.au>
 <CAF+7xWktUYvz1UqNyYsgAwEeap6UefXz+YE1wrRydrCWiMKAAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+7xWktUYvz1UqNyYsgAwEeap6UefXz+YE1wrRydrCWiMKAAg@mail.gmail.com>
X-Cookie: Visit beautiful Vergas, Minnesota.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 11:03:35AM +0800, Axel Lin wrote:
> 2012/1/9 Stephen Rothwell <sfr@canb.auug.org.au>:

> I think this commit should be replaced by [PATCH] ASoC: Fix build
> dependency for SND_AT91_SOC_AFEB9260
> http://mailman.alsa-project.org/pipermail/alsa-devel/2012-January/047861.html

> Should I send a revert patch for commit 739be96ab837? Or you can do it
> by git-revert command directly?

Send an incremental patch to put things into the desired state.
