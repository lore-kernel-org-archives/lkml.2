Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2HTJpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:45:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59188 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2HTJpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:45:46 -0400
Date: Mon, 20 Aug 2012 11:45:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 26/74] lto, sound: Fix export symbols for !CONFIG_MODULES
Message-ID: <20120820094545.GC16230@one.firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-27-git-send-email-andi@firstfloor.org> <s5hzk5qq82i.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hzk5qq82i.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 10:30:29AM +0200, Takashi Iwai wrote:
> At Sat, 18 Aug 2012 19:56:22 -0700,
> Andi Kleen wrote:
> > 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > The new LTO EXPORT_SYMBOL references symbols even without CONFIG_MODULES.
> > Since these functions are macros in this case this doesn't work.
> > Add a ifdef to fix the build.
> > 
> > Cc: tiwai@suse.de
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> Reviewed-by: Takashi Iwai <tiwai@suse.de>
> 
> I haven't seen the background, so let me ask a dumb question:
> is it a 3.6 fix or for 3.7?

I don't strictly need it for 3.6, 3.7 is ok.

> 
> And shall I apply this one to sound git tree, or would you like to
> apply all in a single tree?

Please apply it in yours.

-Andi
