Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab2BPVX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 16:23:56 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:31734 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab2BPVXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 16:23:54 -0500
Date: Thu, 16 Feb 2012 22:23:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Meelis Roos <mroos@linux.ee>, Tejun Heo <tj@kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
Message-ID: <20120216212352.GA11346@merkur.ravnborg.org>
References: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee> <20120213080618.GA11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202131119040.1488@math.ut.ee> <20120213214623.GJ11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202162151030.16208@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1202162151030.16208@math.ut.ee>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 09:53:14PM +0200, Meelis Roos wrote:
> > Ugh; that looks bad.  If it failed there, then the global device node list
> > is corrupted.  I hate to ask you this, but would you be able to git bisect to
> > narrow down the commit that causes the problem?
> 
> Finished bisecting on E2500 (the original machine where I found the 
> problem). Bisecting leads to
> [0ee332c1451869963626bf9cac88f165a90990e1] memblock: Kill early_node_map[]
> So yes, it looks like memblock.

Added Tejun.

	Sam
