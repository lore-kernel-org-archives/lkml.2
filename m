Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab2BFQTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:19:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62181 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab2BFQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:19:49 -0500
Date: Mon, 6 Feb 2012 08:19:43 -0800
From: Tejun Heo <tj@kernel.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Norbert Preining <preining@logic.at>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jian Peng <jipeng2005@gmail.com>
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume,
 COMRESET failed
Message-ID: <20120206161943.GA3926@google.com>
References: <20120203052452.GC24563@gamma.logic.tuwien.ac.at>
 <1328247269.15079.26.camel@minggr>
 <20120203054319.GA25510@gamma.logic.tuwien.ac.at>
 <1328257660.15079.30.camel@minggr>
 <20120206004608.GA9413@gamma.logic.tuwien.ac.at>
 <1328492218.15079.38.camel@minggr>
 <20120206024052.GI9413@gamma.logic.tuwien.ac.at>
 <1328496591.15079.40.camel@minggr>
 <20120206031528.GA16093@gamma.logic.tuwien.ac.at>
 <1328503376.15079.55.camel@minggr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328503376.15079.55.camel@minggr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(cc'ing Jian Peng, hi)

On Mon, Feb 06, 2012 at 12:42:56PM +0800, Lin Ming wrote:
> On Mon, 2012-02-06 at 12:15 +0900, Norbert Preining wrote:
> > On Mo, 06 Feb 2012, Lin Ming wrote:
> > > Only this patch on top of HEAD *without* reverting 7faa33da9b7.
> > 
> > Works. Am I right that it differs from 7faa33da9b7 only in that
> > the later also changes:
> 
> Right.
> 
> Tejun,
> 
> This regression is caused by 7faa33da9b7(ahci: start engine only during
> soft/hard resets).
> 
> But I can't reproduce it.
> 
> What's your guess?

Urgh.... yeah, following standard can sometimes be silly thing to do.
Jian, I think we'll have to add a flag for your controller and revert
to the original behavior for others.  How can your controller be
distinguished?

Thanks.

-- 
tejun
