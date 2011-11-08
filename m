Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab1KHPei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:34:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34170 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756046Ab1KHPee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:34:34 -0500
Date: Tue, 8 Nov 2011 15:34:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/2] ASoC: wm9081: Fix reading wrong register for setting
 VMID 2*240k
Message-ID: <20111108153431.GB5632@opensource.wolfsonmicro.com>
References: <1320475639.8360.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320475639.8360.1.camel@phoenix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 05, 2011 at 02:47:19PM +0800, Axel Lin wrote:
> VMID Divider Enable and Select is controlled by BIT[2:1] of WM9081_VMID_CONTROL
> register (04h).
> Current code reads wrong register (WM9081_BIAS_CONTROL_1) for setting
> VMID 2*240k.

Applied, thanks.
