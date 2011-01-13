Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab1AMRPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:15:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53379 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756855Ab1AMRPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:15:05 -0500
Date: Thu, 13 Jan 2011 17:12:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [uclinux-dist-devel] [PATCH] ASoC: Blackfin TDM: fix missed
 snd_soc_dai_get_drvdata update
Message-ID: <20110113171249.GH30351@opensource.wolfsonmicro.com>
References: <1294805299-5265-1-git-send-email-vapier@gentoo.org>
 <20110113135525.GD11840@opensource.wolfsonmicro.com>
 <AANLkTi=5z0u3un8mGoFChMyzgeGY-tajr3iCC-aR6Dv6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=5z0u3un8mGoFChMyzgeGY-tajr3iCC-aR6Dv6@mail.gmail.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 11:52:02AM -0500, Mike Frysinger wrote:
> On Thu, Jan 13, 2011 at 08:55, Mark Brown wrote:

> > Ccing in Liam - Mike, please remember to CC maintainers on patches - and
> > dropping the stable lists for now.

> i thought you were the ASoC maintainer

We comaintain ASoC, we generally both review everything except during
vacations.
