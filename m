Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab1JRMz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:55:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38954 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab1JRMz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:55:26 -0400
Date: Tue, 18 Oct 2011 13:55:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: alsa-devel <alsa-devel@alsa-project.org>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, David@alsa-project.org,
        Chen <david.chen@diasemi.com>, lrg <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH v4 3/7] ASoC: da7210: Add support for mute
 and zero cross controls
Message-ID: <20111018125519.GB18713@sirena.org.uk>
References: <1318670595.613.42.camel@matrix>
 <20111017214242.GD5200@opensource.wolfsonmicro.com>
 <1318938548.13721.23.camel@matrix>
 <20111018120841.GA28501@opensource.wolfsonmicro.com>
 <1318940943.13721.25.camel@matrix>
 <20111018123124.GC28501@opensource.wolfsonmicro.com>
 <1318942828.13721.39.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318942828.13721.39.camel@matrix>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 06:30:28PM +0530, Ashish Chavan wrote:

> > Eh?  One is a Volume, the other is a Switch.  Note that alsamixer does
> > render the two stacked on top of each other in the UI.

> Yes, I guessed that earlier. Anyways I generally don't rely on alsamixer
> and use amixer whereever possible. In amixer also, it shows only one
> control, the one that I add first. If I change "Mic" to some thing else
> like "MicM" or "Mic Mute", then it shows both controls.

Check again, amixer also merges controls.

> BTW does amixer version have any significance here? I know my alsa-utils
> are quite old (1.0.14)

That's spectacularly old, I guess it's possible it's buggy.
