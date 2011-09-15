Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935516Ab1IOXx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:53:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60603 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934969Ab1IOXx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:53:26 -0400
Date: Fri, 16 Sep 2011 00:53:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 6/6 v3] regmap: Incorporate the regcache core into regmap
Message-ID: <20110915235324.GI3218@opensource.wolfsonmicro.com>
References: <1316082879-21810-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1316082879-21810-7-git-send-email-dp@opensource.wolfsonmicro.com>
 <4E721784.90302@metafoo.de>
 <20110915225703.GC3218@opensource.wolfsonmicro.com>
 <4E728840.407@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E728840.407@metafoo.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 01:20:32AM +0200, Lars-Peter Clausen wrote:

> But for writes the error is propagated to the caller, instead of falling back
> to a hw write. There should be at least consistency between the two.

Hrm, yes we should do that (I haven't actually had time to read this
round yet).

> And I think we should document that regmap_readable and regmap_writeable don't
> prevent actuall hw access, but are merely meant as hints for stuff like caching.

Well, right now we don't enforce anything at all.  I wouldn't object to
a patch for this but once we go out of spec I think we're fine so long
as we're senseible.
