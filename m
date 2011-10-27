Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1J0HRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:17:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43597 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754436Ab1J0HRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:17:03 -0400
Date: Thu, 27 Oct 2011 09:17:00 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chris Paulson-Ellis <chris@edesix.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/2] ASoC: wm8940: Fix mask for setting BCLKDIV
Message-ID: <20111027071659.GB3053@opensource.wolfsonmicro.com>
References: <1319594021.2517.0.camel@phoenix>
 <1319594139.2517.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319594139.2517.2.camel@phoenix>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 09:55:39AM +0800, Axel Lin wrote:
> According to the datasheet:
> BCLK is controlled by BIT[4:2] of WM8940_CLOCK(06h) register.

This doesn't apply against current code.
