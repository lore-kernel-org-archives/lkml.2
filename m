Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab2H1SNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 14:13:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40125 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983Ab2H1SNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 14:13:42 -0400
Date: Tue, 28 Aug 2012 11:13:39 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: ams-delta: fix card initalization
 failure
Message-ID: <20120828181338.GB8796@opensource.wolfsonmicro.com>
References: <1346102910-8610-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <20120827213835.GE4400@opensource.wolfsonmicro.com>
 <3048168.EXxi4fR4e7@acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3048168.EXxi4fR4e7@acer>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 05:13:05PM +0200, Janusz Krzysztofik wrote:
> On Mon, 27 Aug 2012 14:38:35 Mark Brown wrote:
> > On Mon, Aug 27, 2012 at 11:28:30PM +0200, Janusz Krzysztofik wrote:

> > > -	platform_set_drvdata(ams_delta_audio_platform_device,
> > > -				&ams_delta_audio_card);

> > The real fix here is that you should be using platform data here, not
> > driver data.  Is there some reason not to do that?

> Do you think the change you propose is suitable for the rc cycle? I'm 
> trying to fix a regression in the first place. Converting the ams-delta 
> asoc to a platform driver is on my todo list and I'm going to take care 
> of this as soon as I have enough spare time.

The above looks like you already have a platform driver?  All I'm
suggesting is changing the above to use platform rather than driver
data.
