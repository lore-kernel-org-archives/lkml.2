Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab1IDOk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 10:40:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33057 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753752Ab1IDOkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 10:40:25 -0400
Date: Sun, 4 Sep 2011 07:10:15 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnaud Patard <arnaud.patard@rtp-net.org>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: codecs: Remove unused mutex
Message-ID: <20110904141015.GB3668@opensource.wolfsonmicro.com>
References: <1315140751.8673.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315140751.8673.1.camel@phoenix>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 04, 2011 at 08:52:31PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  sound/soc/codecs/alc5623.c |    2 --
>  sound/soc/codecs/wm9090.c  |    2 --

This has already been done for wm9090, can you resubmit with just the
alc5623 change please?
