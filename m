Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1FULz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 07:55:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39619 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1FULzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 07:55:53 -0400
Date: Tue, 21 Jun 2011 12:55:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Taylor Hutt <thutt@chromium.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Olof Johansson <olofj@chromium.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: codecs: Max98095: Fix logging of hardware
	revision.
Message-ID: <20110621115547.GD25032@sirena.org.uk>
References: <1308596072-17158-1-git-send-email-thutt@chromium.org> <20110621002322.GE1905@opensource.wolfsonmicro.com> <B2150E1E4418E1438554A300EA5040E40DDEC16D42@ITSVLEX06.it.maxim-ic.internal> <20110621011038.GA4322@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621011038.GA4322@opensource.wolfsonmicro.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 02:10:39AM +0100, Mark Brown wrote:
> On Mon, Jun 20, 2011 at 05:43:58PM -0700, Peter Hsiang wrote:

> > I checked with hardware engineering and was told 0x40=RevA, 0x41=RevB..

> > Would a raw value or the use of a 0x3F bit mask be more acceptable?

> I don't mind (though it does seem like the high bit isn't part of the
> actual data), it was just that it's a common error to assume that die
> revisions and package revisions correspond directly.

This means if you're OK with it I can apply the patch as-is, BTW.
