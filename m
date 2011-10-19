Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab1JSISH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 04:18:07 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:57915 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989Ab1JSISF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 04:18:05 -0400
Message-ID: <1319012280.4133.0.camel@odin>
Subject: Re: [PATCH] ASoC: ssm2602: Use snd_soc_update_bits for
 read-modify-write
From: Liam Girdwood <lrg@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org
Date: Wed, 19 Oct 2011 09:18:00 +0100
In-Reply-To: <1319004451.16275.1.camel@phoenix>
References: <1319004451.16275.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-19 at 14:07 +0800, Axel Lin wrote:
> Use snd_soc_update_bits for read-modify-write register access instead of
> open-coding it using snd_soc_read and snd_soc_write
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Liam Girdwood <lrg@ti.com>


