Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934989Ab1JEQR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:17:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53693 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934476Ab1JEQRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:17:24 -0400
Date: Wed, 5 Oct 2011 17:17:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/2] ASoC: Remove unused function declaration in imx-ssi.h
Message-ID: <20111005161721.GD11528@opensource.wolfsonmicro.com>
References: <1317796846.21481.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317796846.21481.1.camel@phoenix>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 02:40:46PM +0800, Axel Lin wrote:
> These functions are removed in commit f0fba2ad
> "ASoC: multi-component - ASoC Multi-Component Support".
> Let's remove the leftover function declaration in header file.

Applied, thanks.
