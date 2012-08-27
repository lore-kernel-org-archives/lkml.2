Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab2H0Vij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 17:38:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39366 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754329Ab2H0Vii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 17:38:38 -0400
Date: Mon, 27 Aug 2012 14:38:35 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lrg@ti.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: ams-delta: fix card initalization failure
Message-ID: <20120827213835.GE4400@opensource.wolfsonmicro.com>
References: <1346102910-8610-1-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346102910-8610-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 11:28:30PM +0200, Janusz Krzysztofik wrote:

> -	platform_set_drvdata(ams_delta_audio_platform_device,
> -				&ams_delta_audio_card);
> -
> -	ret = platform_device_add(ams_delta_audio_platform_device);
> -	if (ret)
> -		goto err;

The real fix here is that you should be using platform data here, not
driver data.  Is there some reason not to do that?
