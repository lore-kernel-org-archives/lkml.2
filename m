Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2CXPXI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 11:23:08 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37535 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab2CXPXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 11:23:06 -0400
MIME-Version: 1.0
In-Reply-To: <1332511242-30241-1-git-send-email-alexandre.bounine@idt.com>
References: <1332511242-30241-1-git-send-email-alexandre.bounine@idt.com>
Date: Sat, 24 Mar 2012 12:23:03 -0300
Message-ID: <CAOMZO5B-Zutv-xwqLCAgNMO8A3Kyg4uWqS41koo-yoS4mGB1TQ@mail.gmail.com>
Subject: Re: [PATCH linux-next] dmaengine: add context parameter fixups
From: Fabio Estevam <festevam@gmail.com>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: paul.gortmaker@windriver.com, vinod.koul@intel.com,
        dan.j.williams@intel.com, samuel@sortiz.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, fabio.estevam@freescale.com,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 11:00 AM, Alexandre Bounine
<alexandre.bounine@idt.com> wrote:
> This patch fixes drivers that use device_prep_slave_sg() and
> device_prep_dma_cyclic() interfaces and have been missed during the initial
> release of interface changing patches.
>
> This patch is based on linux-next-20120322 code tree.
> See https://lkml.org/lkml/2012/3/22/339 for build failure report.
>
> Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
> Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  drivers/dma/sa11x0-dma.c      |    2 +-
>  drivers/net/irda/sa1100_ir.c  |    2 +-
>  sound/soc/sh/fsi.c            |    7 +++----
>  sound/soc/soc-dmaengine-pcm.c |    2 +-

I have already taken care of sound/soc/soc-dmaengine-pcm.c:
http://permalink.gmane.org/gmane.linux.alsa.devel/96215
