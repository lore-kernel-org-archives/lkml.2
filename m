Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab1JMQiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:38:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43853 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756124Ab1JMQiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:38:51 -0400
Date: Thu, 13 Oct 2011 17:38:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: tlv320aic32x4: Use snd_soc_update_bits for
 read-modify-write
Message-ID: <20111013163849.GN5193@opensource.wolfsonmicro.com>
References: <1318517794.4554.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318517794.4554.4.camel@phoenix>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 10:56:34PM +0800, Axel Lin wrote:
> Use snd_soc_update_bits for read-modify-write register access instead of
> open-coding it using snd_soc_read and snd_soc_write.

Applied, thanks.
