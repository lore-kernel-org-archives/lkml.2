Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab1KHPjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:39:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51766 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122Ab1KHPi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:38:58 -0500
Date: Tue, 8 Nov 2011 15:38:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/2] ASoC: wm9081: Don't write WM9081_BIAS_ENA bit to
 WM9081_VMID_CONTROL register
Message-ID: <20111108153856.GD5632@opensource.wolfsonmicro.com>
References: <1320475639.8360.1.camel@phoenix>
 <1320475761.8360.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320475761.8360.3.camel@phoenix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 05, 2011 at 02:49:21PM +0800, Axel Lin wrote:
> WM9081_BIAS_ENA is the bit[1] of WM9081_BIAS_CONTROL_1 register (05h).
> Current code incorrectly write it to WM9081_VMID_CONTROL(04h) register.

This one seems to work happily - applied, thanks!
