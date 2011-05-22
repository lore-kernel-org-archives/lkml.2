Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab1EVHFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 03:05:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60887 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751380Ab1EVHF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 03:05:28 -0400
Date: Sun, 22 May 2011 15:05:27 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, balbi@ti.com, lrg@slimlogic.co.uk,
        linux@slimlogic.co.uk, lrg@ti.com, balajitk@ti.com
Subject: Re: [PATCH v3 1/2] REGULATOR: TWL6025: add support to twl-regulator
Message-ID: <20110522070526.GC18955@opensource.wolfsonmicro.com>
References: <1305743570-12074-1-git-send-email-gg@slimlogic.co.uk>
 <1305743570-12074-2-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305743570-12074-2-git-send-email-gg@slimlogic.co.uk>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 07:32:49PM +0100, Graeme Gregory wrote:
> Adding support for the twl6025. Major difference in the twl6025 is the
> group functionality has been removed from the chip so this affects how
> regulators are enabled and disabled.
> 
> The names of the regulators also changed.

I rather fear this will collide with the patches that Balaji T K just
sent...
