Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab2ABMsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 07:48:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48568 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751887Ab2ABMsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 07:48:03 -0500
Date: Mon, 2 Jan 2012 12:48:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lrg@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v2 4/4] ASoC: OMAP: ams-delta: drop .set_bias_level
 callback
Message-ID: <20120102124759.GG4300@opensource.wolfsonmicro.com>
References: <1325214296-2888-5-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325214296-2888-5-git-send-email-jkrzyszt@tis.icnet.pl>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 04:04:56AM +0100, Janusz Krzysztofik wrote:
> This functionality has just been implemented in the cx20442 codec
> driver, no need to keep it here duplicated.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
