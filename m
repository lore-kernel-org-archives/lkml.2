Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab0KHK1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 05:27:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:10127 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab0KHK1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 05:27:33 -0500
Message-Id: <b9dded$h0q3am@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,313,1286175600"; 
   d="scan'208";a="571280726"
Date: Mon, 08 Nov 2010 10:27:29 +0000
To: Jon Masters <jonathan@jonmasters.org>
Subject: Re: [bisected] offset display bug in i915
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1289211512.3916.383.camel@constitution.bos.jonmasters.org>
References: <1289211512.3916.383.camel@constitution.bos.jonmasters.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Nov 2010 05:18:32 -0500, Jon Masters <jonathan@jonmasters.org> wrote:
> Hi Chris,
> 
> The following patch that you recently committed breaks my ASUS Eee PC
> 1015PEM by causing the display to be offset by about 1 inch (a few
> centimeters) when the mode is (re)set during boot. I previously posted
> both photographs and video of the problem in another "PROBLEM" thread.

[snip]

> I'll look at the patch. Either the EDID is *not* consistent (in which
> case, why are we not seeing other bugs like this?) or there is something
> specific to this system or panel used.

Interesting. Or even downright bizarre! Can you disable the caching
(hopefully the patch is still revertible) and save the EDID
(/sys/class/drm/card0-LVDS-1/edid) periodically? Might be simplest just to
dump the EDID every time we probe the LVDS if it has changed.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
