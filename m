Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1JBUgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:36:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39545 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754458Ab1JBUgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:36:16 -0400
Date: Sun, 2 Oct 2011 21:36:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/6] ASoC: codecs/wm8682: use __devexit_p
Message-ID: <20111002203613.GA5811@opensource.wolfsonmicro.com>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
 <1317587284-2776-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317587284-2776-2-git-send-email-arnd@arndb.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 10:27:59PM +0200, Arnd Bergmann wrote:
> This fixes a build error when CONFIG_HOTPLUG is disabled.

Axel Lin sent a patch for this recently, it's already been merged.

>  sound/soc/codecs/wm8782.c |    2 +-

Your subject line doesn't match the file you're changing.
