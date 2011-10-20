Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab1JTOIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 10:08:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55011 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755209Ab1JTOIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 10:08:19 -0400
Date: Thu, 20 Oct 2011 15:08:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Joonyoung Shim <jy0922.shim@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: ak4671: Use snd_soc_update_bits for
 read-modify-write
Message-ID: <20111020140817.GC3524@opensource.wolfsonmicro.com>
References: <1319079253.5380.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319079253.5380.3.camel@phoenix>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 10:54:13AM +0800, Axel Lin wrote:
> Use snd_soc_update_bits for read-modify-write register access instead of
> open-coding it using snd_soc_read and snd_soc_write

Applied, thanks.
