Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0K3LYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 06:24:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39028 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751159Ab0K3LYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 06:24:49 -0500
Date: Tue, 30 Nov 2010 11:24:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, dg@emlix.com,
        Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Fix compile error for s6000-i2s.c by adding a
 missing ';' character
Message-ID: <20101130112447.GD7403@rakim.wolfsonmicro.main>
References: <1291081553.18485.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291081553.18485.3.camel@mola>
X-Cookie: To teach is to learn.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 09:45:53AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> I don't have toolchain to compile s6000, I'm not able to put the error message in the commit log.
> But I know this patch indeed fixes a compile error.

Daniel already posted the same patch (and a bunch of others), just
waiting for Liam's review.  The S6000 port as a whole doesn't compile
anyway at the minute (due to arch/ side issues).
