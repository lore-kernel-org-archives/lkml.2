Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2FFMI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 08:08:57 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18192 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2FFMIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 08:08:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 06 Jun 2012 05:08:30 -0700
Date: Wed, 6 Jun 2012 15:07:54 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@ti.com>
CC: Rajendra Nayak <rnayak@ti.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120606120754.GU8026@tbergstrom-lnx.Nvidia.com>
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
 <4FC5E837.30702@ti.com>
 <20120531191916.GA19475@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120531191916.GA19475@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 09:19:16PM +0200, Mike Turquette wrote:
> On 20120530-14:58, Rajendra Nayak wrote:
> > Hi Peter,
> > 
> > On Tuesday 29 May 2012 03:28 PM, Peter De Schrijver wrote:
> > >Add an extension API for clocks. This allows clocktypes to provide extensions
> > >for features which are uncommon and cannot be easily mapped onto normal clock
> > >framework concecpts. eg: resetting blocks, configuring clock phase etc.
> > 
> > I was thinking on similar lines for OMAP wherein I need to control
> > 'hardware-auto-gating' bits on clocks which are otherwise just normal
> > gates or dividers. We just disable all of them early at boot and
> > re-enable them late in the boot process once PM kicks in.
> > 
> 
> It would be helpful to get an idea of what these different functions
> actually do.  This patch exposes a sort of poor man's ioctl/syscall
> interface (which may indeed be necessary), but I would first prefer to
> pool together everybody's needs and see if some new high-level APIs
> should be added to clk.h.
> 
> Already a clk_reset/module reset call has been discussed in this thread.
> The changelog discusses setting clock phase and Rajendra mentioned
> controlling auto-gating behavior.
> 
> Do other folks have these same needs?  What about other needs that are
> unlisted?  Please add them to the thread so we can get an idea of what
> we're up against.

* clock phase (invert or programmable delay)
* external request line configuration

Cheers,

Peter.
