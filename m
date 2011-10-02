Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab1JBUuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:50:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39943 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979Ab1JBUuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:50:10 -0400
Date: Sun, 2 Oct 2011 21:50:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/6] ASoC: sh: use correct __iomem annotations
Message-ID: <20111002205008.GB4506@opensource.wolfsonmicro.com>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
 <1317587284-2776-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317587284-2776-5-git-send-email-arnd@arndb.de>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 10:28:02PM +0200, Arnd Bergmann wrote:
> This removes a few unnecessary type casts and avoids
> sparse warnings.

Applied, thanks.
