Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1JLKZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 06:25:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37999 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684Ab1JLKZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 06:25:32 -0400
Date: Wed, 12 Oct 2011 11:25:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH v2] ASoC: Remove impossible case from wm8994_hw_params
Message-ID: <20111012102530.GE3647@opensource.wolfsonmicro.com>
References: <1318374189.6115.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318374189.6115.3.camel@phoenix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 07:03:09AM +0800, Axel Lin wrote:
> We set hw_params callback for wm8994_aif3_dai_ops to wm8994_aif3_hw_params.
> Thus no need to check wm8994-aif3 in wm8994_hw_params.

Applied, thanks.
