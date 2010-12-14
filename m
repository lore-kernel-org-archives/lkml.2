Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810Ab0LNTys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 14:54:48 -0500
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:61369 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759578Ab0LNTyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 14:54:47 -0500
X-Loopcount0: from 143.166.82.43
Date: Tue, 14 Dec 2010 13:54:45 -0600
From: Matt Domsch <Matt_Domsch@Dell.com>
To: Narendra_K@Dell.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jordan_Hargrave@Dell.com, Charles_Rose@Dell.com
Subject: Re: [PATCH] Enable pci=bfsort by default on future Dell systems
Message-ID: <20101214195445.GA31714@auslistsprd01.us.dell.com>
References: <20101214175048.GC31345@fedora-14-r710.oslab.blr.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214175048.GC31345@fedora-14-r710.oslab.blr.amer.dell.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 09:57:12AM -0800, Narendra_K@Dell.com wrote:
> Hello,
> 
> This patch enables pci=bfsort by default on future Dell systems.
> Please consider for inclusion if acceptable.
> 
> From: Jordan Hargrave <jordan_hargrave@dell.com>
> Subject: [PATCH] Enable pci=bfsort by default on future Dell systems

You may be asking "why is this necessary with the biosdevname work
going on?".  Short story is, yes, biosdevname continues to be the
medium-term strategy, and we are addressing as much as we can in that,
getting into all the distributions future releases, adding it in the
distro installer environments.  However, biosdevname adoption has been
slow (I started writing it 5 years ago), and there's a good chance it
won't be picked up by all older distribution releases in Service
Packs, Updates, or the like.  By continuing to use the pci=bfsort
workaround, we can more likely get this small patch into older
distribution update relesaes where we are already doing hardware
enablement, as it can only affect future Dell servers, no impact to
existing systems or installations.  It also gives flexibility to
current kernels and distribution releases on when they pick up
biosdevname.  The two (pci=bfsort and biosdevname) do not conflict in
any way.

So, I encourage adoption of this small kernel patch, and then
encourage distros to pick up biosdevname also.

Thanks,
Matt

-- 
Matt Domsch
Technology Strategist
Dell | Office of the CTO
