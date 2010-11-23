Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab0KWOx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:53:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38543 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754754Ab0KWOxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:53:55 -0500
Date: Tue, 23 Nov 2010 14:53:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: alsa-devel@alsa-project.org, Jon Smirl <jonsmirl@gmail.com>,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        linuxppc-dev@lists.ozlabs.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] MPC5200: Eliminate duplicate include of of_device.h
Message-ID: <20101123145352.GM18960@rakim.wolfsonmicro.main>
References: <alpine.LNX.2.00.1011222246250.6285@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011222246250.6285@swampdragon.chaosbits.net>
X-Cookie: Must be under 48 inches in height.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 10:54:03PM +0100, Jesper Juhl wrote:
> 
> Eliminate duplicate  #include <linux/of_device.h>  from 
> sound/soc/fsl/mpc5200_dma.c

Applied, thanks.
