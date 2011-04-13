Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab1DMHny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 03:43:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42330 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab1DMHnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 03:43:53 -0400
Subject: Re: [alsa-devel] [PATCH] ARM: s3c2440: gta02; Register dfbmcs320
 device
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1302641464-27494-1-git-send-email-lars@metafoo.de>
References: <1302641464-27494-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 08:43:48 +0100
Message-ID: <1302680628.3600.15.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 22:51 +0200, Lars-Peter Clausen wrote:
> Register the dfbmcs320 device which provides the PCM DAI for the bluetooth
> module.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> ---
>  arch/arm/mach-s3c2440/mach-gta02.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 

Acked-by: Liam Girdwood <lrg@ti.com>

