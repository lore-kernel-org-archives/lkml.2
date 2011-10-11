Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1JKNdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:33:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43672 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699Ab1JKNdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:33:22 -0400
Date: Tue, 11 Oct 2011 14:33:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Writing register default value for the reset
 register
Message-ID: <20111011133321.GC3471@opensource.wolfsonmicro.com>
References: <1318326900.3526.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318326900.3526.2.camel@phoenix>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 05:55:00PM +0800, Axel Lin wrote:
> The WM8983 can be reset by performing a write of any value to
> the software reset register.

Applied, thanks.
