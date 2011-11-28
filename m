Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1K1W6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:58:32 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54614 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab1K1W6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:58:31 -0500
Date: Mon, 28 Nov 2011 22:58:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] mfd: Enable register cache for wm8994 devices
Message-ID: <20111128225829.GC16133@sirena.org.uk>
References: <20111128224017.GA13163@opensource.wolfsonmicro.com>
 <1322520274-13789-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1322520274-13789-8-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322520274-13789-8-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: To stay youthful, stay useful.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 10:44:34PM +0000, Mark Brown wrote:
> As part of this we provide information about the registers that exist in
> the device to the regmap core, drop the small amount of cache that the
> core had been using and let regmap do the sync.

Oh, and I forgot that this one depends on a regmap patch (regmap: Track
if the register cache is dirty and suppress unneeded syncs).  I've
rebuilt the branch with the appropriate merge in it.
