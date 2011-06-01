Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab1FAXcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 19:32:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:18119 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236Ab1FAXcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 19:32:13 -0400
X-ExtLoop1: 1
Date: Wed, 1 Jun 2011 16:32:01 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH 2/2] xhci: Do not issue device reset when device
 is not setup
Message-ID: <20110601233201.GA25067@xanatos>
References: <1306963670-6344-1-git-send-email-m.b.lankhorst@gmail.com>
 <1306963670-6344-2-git-send-email-m.b.lankhorst@gmail.com>
 <20110601221722.GB17429@kroah.com>
 <20110601224205.GC13079@xanatos>
 <4DE6C4EE.8020807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE6C4EE.8020807@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 01:02:06AM +0200, Maarten Lankhorst wrote:
> Hi Sarah,
> 
> Op 02-06-11 00:42, Sarah Sharp schreef:
> > Maarten, if you feel a patch needs to be added to the stable trees,
> > please just add this line below your Signed-off-by line:
> >
> > Cc: stable@kernel.org
> >
> > Don't Cc stable in your initial RFC patches.  Once they're done, I'll
> > queue them to my xHCI tree and send them off to Greg.  When Greg sends
> > them off to Linus for inclusion into 3.0, the patches will automatically
> > get picked up into the stable tree.
> Sorry about that. I interpreted cc'ing stable wrongly, feel like such a
> noob on this whole submitting patches thing. :)

No worries!  Everyone has to start somewhere.

> I do think it needs inclusion in stable though, since it fixes the
> xhci controller that so far never worked for me, although the earliest
> kernel I tested on was v2.6.33.$x-rt$y. Didn't test the patch though,
> but iirc the failure mode wasn't any different.

Ok, but do these two patches fix the problem you're seeing on the Etron
xHCI host controller on 2.6.39 or 3.0?

Sarah Sharp
