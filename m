Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1ALPGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 10:06:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46079 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753793Ab1ALPGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 10:06:01 -0500
Date: Wed, 12 Jan 2011 15:06:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, stable@kernel.org
Subject: Re: [PATCH] ASoC: Fix parameter for soc_unregister_ac97_dai_link
Message-ID: <20110112150616.GE14870@opensource.wolfsonmicro.com>
References: <1294797775.20409.4.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294797775.20409.4.camel@mola>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 10:02:55AM +0800, Axel Lin wrote:
> soc_unregister_ac97_dai_link takes a pointer to a codec.
> 
> Reported-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: stable@kernel.org  [2.6.37]

This only applies in stable - it is a backport of 7d8316d (ASoC: Fix
AC'97 registration unwind) which should be going in during the merge
window.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
