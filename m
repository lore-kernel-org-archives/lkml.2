Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2BVRWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:22:01 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:36745 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab2BVRV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:21:56 -0500
Date: Wed, 22 Feb 2012 18:21:54 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Tejun Heo <tj@kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
Message-ID: <20120222172154.GA29641@merkur.ravnborg.org>
References: <20120213080618.GA11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202131119040.1488@math.ut.ee> <20120213214623.GJ11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202162151030.16208@math.ut.ee> <alpine.SOC.1.00.1202201109260.467@math.ut.ee> <20120220170603.GC7836@mtj.dyndns.org> <alpine.SOC.1.00.1202210030530.11350@math.ut.ee> <20120221010537.GA15898@dhcp-172-17-108-109.mtv.corp.google.com> <20120222170330.GA29521@merkur.ravnborg.org> <alpine.SOC.1.00.1202221910420.17363@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1202221910420.17363@math.ut.ee>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 07:12:06PM +0200, Meelis Roos wrote:
> > Meelis - do the affected boxes have any special memory configurations?
> 
> Nothin special to me. E3500 has 2G, V100 has 1G, V210 and V240 have 2G 
> and 1.5G.
> 
> > Could you try to boot with a sensible mem=xxx value to see if limiting the memory
> > helps.
> 
> Like mem=256M? Will try.
Think just a little more - I do not think this will help.
I confused myself with some of the sparc32 issues I have hit.

I have looked a little at the log files you included.
The only thing that looked different was that the faulty version
had a number after "@" which is higher than 1 - where the OK always have 1.

This is "idx" in memblock_insert_region() - but I did not look closer.

	Sam
