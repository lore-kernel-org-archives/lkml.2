Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab1J0KAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 06:00:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33080 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754944Ab1J0KAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 06:00:50 -0400
Date: Thu, 27 Oct 2011 12:00:48 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chris Paulson-Ellis <chris@edesix.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH v2] ASoC: wm8940: Fix mask for setting BCLKDIV
Message-ID: <20111027100048.GC22369@opensource.wolfsonmicro.com>
References: <1319704053.2673.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319704053.2673.0.camel@phoenix>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 04:27:33PM +0800, Axel Lin wrote:
> According to the datasheet:
> BCLK is controlled by BIT[4:2] of WM8940_CLOCK(06h) register.

Applied, thanks.
