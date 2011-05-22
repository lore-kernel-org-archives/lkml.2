Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab1EVWtG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 18:49:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54932 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755438Ab1EVWtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 18:49:03 -0400
Date: Mon, 23 May 2011 06:48:59 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        lrg@slimlogic.co.uk, lrg@ti.com, linux@slimlogic.co.uk,
        balajitk@ti.com
Subject: Re: [PATCH v4 1/2] REGULATOR: TWL6025: add support to twl-regulator
Message-ID: <20110522224857.GA15882@opensource.wolfsonmicro.com>
References: <1306095684-7732-1-git-send-email-gg@slimlogic.co.uk>
 <1306095684-7732-2-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306095684-7732-2-git-send-email-gg@slimlogic.co.uk>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 09:21:23PM +0100, Graeme Gregory wrote:
> Adding support for the twl6025. Major difference in the twl6025 is the
> group functionality has been removed from the chip so this affects how
> regulators are enabled and disabled.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> Since V1
> 
> Use the features variable passed via platform data instead of calling
> global function.

Change histories like this should usually come after the --- so things
like git am strip them out of what actually ends up in git.
