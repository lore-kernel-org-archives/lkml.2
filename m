Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab0K2LrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 06:47:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41469 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752840Ab0K2LrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 06:47:03 -0500
Date: Mon, 29 Nov 2010 11:47:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Wan ZongShun <mcuos.com@gmail.com>, alsa-devel@alsa-project.org
Subject: Re: [RFC][PATCH 4/5] ASoC: Fix missing spin_unlock_irqrestore
Message-ID: <20101129114700.GP30360@rakim.wolfsonmicro.main>
References: <1291023491.22911.1.camel@mola>
 <1291023767.22911.9.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291023767.22911.9.camel@mola>
X-Cookie: Sentient plasmoids are a gas.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 05:42:47PM +0800, Axel Lin wrote:

> I don't have this hardware handy, could you help to test this patch
> if you think this patch is ok.

I've applied everything except this one - Wan, can you let us know how
the testing goes please?
