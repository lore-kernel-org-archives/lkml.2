Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab1JTJr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:47:56 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:42991 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932098Ab1JTJrz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:47:55 -0400
MIME-Version: 1.0
In-Reply-To: <1319079253.5380.3.camel@phoenix>
References: <1319079253.5380.3.camel@phoenix>
Date: Thu, 20 Oct 2011 10:47:53 +0100
Message-ID: <CABS+qY3XFUgc3ZVGJdCtLoM_6a6Y3Z6NkqdXj+Rv45DNCYe8qQ@mail.gmail.com>
Subject: Re: [PATCH] ASoC: ak4671: Use snd_soc_update_bits for read-modify-write
From: "Girdwood, Liam" <lrg@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Joonyoung Shim <jy0922.shim@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 October 2011 03:54, Axel Lin <axel.lin@gmail.com> wrote:
> Use snd_soc_update_bits for read-modify-write register access instead of
> open-coding it using snd_soc_read and snd_soc_write
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/ak4671.c |   18 ++++++------------
>  1 files changed, 6 insertions(+), 12 deletions(-)
>

Acked-by: Liam Girdwood <lrg@ti.com>
