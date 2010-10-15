Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab0JOKj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 06:39:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59234 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751608Ab0JOKj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 06:39:26 -0400
Date: Fri, 15 Oct 2010 11:39:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Peter Hsiang <Peter.Hsiang@maxim-ic.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
Subject: Re: [PATCH] sound/soc/codecs/wm8994.c: Remove unused vol
Message-ID: <20101015103923.GE14782@rakim.wolfsonmicro.main>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
 <B2150E1E4418E1438554A300EA5040E40D469C124F@ITSVLEX06.it.maxim-ic.internal>
 <1286934472.1117.129.camel@Joe-Laptop>
 <20101013082414.GD6424@rakim.wolfsonmicro.main>
 <1286971846.1117.191.camel@Joe-Laptop>
 <20101013123301.GL6424@rakim.wolfsonmicro.main>
 <1286983191.1117.338.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286983191.1117.338.camel@Joe-Laptop>
X-Cookie: Don't get even -- get odd!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 08:19:51AM -0700, Joe Perches wrote:
> Remove unused vol from struct access_mask

Applied, thanks.

Please try to use subject lines for your patches consistent with the
rest of the subsystem.
