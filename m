Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0LALg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:36:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39770 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751464Ab0LALgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:36:25 -0500
Date: Wed, 1 Dec 2010 11:36:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jarkko Nikula <jhnikula@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] ASoC: Fix build failure in soc-core.c
Message-ID: <20101201113623.GI24176@rakim.wolfsonmicro.main>
References: <20101201113138.f6146790.sfr@canb.auug.org.au>
 <1291187447-1247-1-git-send-email-jhnikula@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291187447-1247-1-git-send-email-jhnikula@gmail.com>
X-Cookie: << WAIT >>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 09:10:47AM +0200, Jarkko Nikula wrote:
> Commit 2eea392 "ASoC: Add support for optional auxiliary dailess codecs"
> causes a build failure in soc-core.c: soc_probe_aux_dev since code tries to
> access non-existing struct snd_soc_dapm_context and struct snd_soc_card
> members.

Applied, thanks.
