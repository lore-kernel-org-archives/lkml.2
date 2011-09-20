Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab1ITK5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 06:57:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41118 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1ITK5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 06:57:19 -0400
Date: Tue, 20 Sep 2011 11:57:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: alsa-devel@alsa-project.org, Dmitry Torokhov <dtor@mail.ru>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 7/8] ASoC: omap-mcpdm: Correct the
 supported number of channels
Message-ID: <20110920105714.GA14609@sirena.org.uk>
References: <1316091561-30899-1-git-send-email-peter.ujfalusi@ti.com>
 <1316091561-30899-8-git-send-email-peter.ujfalusi@ti.com>
 <20110919221740.GI23179@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110919221740.GI23179@opensource.wolfsonmicro.com>
X-Cookie: Who's scruffy-looking?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 11:17:40PM +0100, Mark Brown wrote:
> On Thu, Sep 15, 2011 at 03:59:20PM +0300, Peter Ujfalusi wrote:
> > OMAP4 McPDM supports 5 downlink (playback), and
> > 3 uplink (capture) channels.

> Applied, thanks.

No I didn't - I guess this one only applies against Liam's tree

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
