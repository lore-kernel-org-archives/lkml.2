Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2HYRRO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 13:17:14 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59291 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750873Ab2HYRRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 13:17:11 -0400
Date: Sat, 25 Aug 2012 19:17:05 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 03/19] x86, io_apic: Introduce x86_io_apic_ops.disable()
Message-ID: <20120825171705.GC3363@breakpoint.cc>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-4-git-send-email-joerg.roedel@amd.com>
 <20120823211140.GB7120@breakpoint.cc>
 <20120824122226.GW2582@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824122226.GW2582@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 02:22:26PM +0200, Joerg Roedel wrote:
> Well, yeah, the confusing thing with this patch is, that it does not only
> introduce the x86_io_apic_ops.disable call-back but also adds the
> infrastructure to change this op (and others). So the infrastructure
> change should probably be in a seperate patch. But on the other side the
> infrastructure change is small and the patch-set is already really
> large.
> Is it worth it to split that out?

I don't insist to redo the patch because of this. Please redo the patch
description to better describe what you do. You pull the "irq remap" code out
and stuff it in another function.

> > I don't want sound to picky here but the term 'modify' is bad I think. Would
> > 'overwrite' fit better here? Is 'modify' used someplace else in x86 so you
> > follow a common pattern here? Maybe it is just me.
> 
> Probably it's just me, but overwrite sounds like 'replace' (== overwrite
> all ops with own values). But the code changes only a few of the ops
> which need different behavior for interrupt remapping. I think 'modify'
> describes that better, no?

Leave it then :)

> 
> 
> 	Joerg

Sebastian
