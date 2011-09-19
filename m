Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab1ISKMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 06:12:44 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60071 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab1ISKMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 06:12:43 -0400
Date: Mon, 19 Sep 2011 11:12:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: [alsa-devel] [PATCH 00/17] ASoC: twl6040: Cleanups and fixes
Message-ID: <20110919101235.GA5467@sirena.org.uk>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Pass with care.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 03:39:22PM +0300, Peter Ujfalusi wrote:

> The first four patch of this series (the MFD/Input patches) has been already
> sent to upstream to the relevant lists, but I wanted to include here as well,
> since I have dependency on that series later on.
> If it is OK with you, it would be best to merge these MFD/Input changes through
> the audio tree for 3.2.

It'd be really good if you could manage to split this stuff up - this
series is enormous and it's getting posted rather a lot, much of this
stuff seems like it could be split out and posted separately.
