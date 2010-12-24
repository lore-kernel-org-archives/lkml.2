Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab0LXO44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 09:56:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38440 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752539Ab0LXO4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 09:56:55 -0500
Date: Fri, 24 Dec 2010 14:57:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] ASoC: codecs: Fix register cache incoherencies
Message-ID: <20101224145706.GA16614@opensource.wolfsonmicro.com>
References: <1293198484-1902-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293198484-1902-1-git-send-email-lars@metafoo.de>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 02:47:55PM +0100, Lars-Peter Clausen wrote:
> The multi-component patch(commit f0fba2ad1) introduced a generic register cache
> framework. Most of the drivers where converted to use this new framework. But

No it didn't - soc-cache.c has been present since the middle of 2009.
