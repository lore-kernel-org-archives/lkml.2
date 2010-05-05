Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123Ab0EEIAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 04:00:22 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:59793 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294Ab0EEIAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 04:00:21 -0400
Date: Wed, 5 May 2010 10:00:15 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Jakob Viketoft <jakob.viketoft@bitsim.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] colibri.h: Fix building for colibri 270...
Message-ID: <20100505080015.GD30801@buzzloop.caiaq.de>
References: <4BC8330E.6000503@bitsim.com>
 <20100416100126.GI30801@buzzloop.caiaq.de>
 <4BC84766.5060208@bitsim.com>
 <4BC8493D.60900@bitsim.com>
 <20100416112820.GM30801@buzzloop.caiaq.de>
 <20100416112931.GN30801@buzzloop.caiaq.de>
 <n2mf17812d71005050045x4359dfeu2f563c3ac0a42223@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n2mf17812d71005050045x4359dfeu2f563c3ac0a42223@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 03:45:34PM +0800, Eric Miao wrote:
> On Fri, Apr 16, 2010 at 7:29 PM, Daniel Mack <daniel@caiaq.de> wrote:
> > On Fri, Apr 16, 2010 at 01:28:20PM +0200, Daniel Mack wrote:
> >> On Fri, Apr 16, 2010 at 01:25:49PM +0200, Jakob Viketoft wrote:
> >> > Adding a "#include <mach/mfp.h>" seem to cure this problem. If you
> >> > agree I can supply a new patch with the correct solution this time.
> >>
> >> Ok. Add it to colibri.h, and while at it, you can kick the ax88796.h
> >> inclusion. That's a leftover and isn't needed.
> >
> > And Cc: stable@kernel.org for the backmerge to 2.6.33.
> >
> 
> Jakob, any update on this?

Jakob provided an updated patch for this:

  http://lkml.org/lkml/2010/4/16/100


