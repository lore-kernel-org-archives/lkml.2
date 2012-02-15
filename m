Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2BOSbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 13:31:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46638 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab2BOSbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 13:31:45 -0500
Date: Wed, 15 Feb 2012 10:31:39 -0800
From: Tejun Heo <tj@kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Norbert Preining <preining@logic.at>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jian Peng <jipeng2005@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>, valdis.kletnieks@vt.edu,
        Mark Lord <kernel@teksavvy.com>
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume,
 COMRESET failed
Message-ID: <20120215183139.GC24986@google.com>
References: <20120206024052.GI9413@gamma.logic.tuwien.ac.at>
 <1328496591.15079.40.camel@minggr>
 <20120206031528.GA16093@gamma.logic.tuwien.ac.at>
 <1328503376.15079.55.camel@minggr>
 <20120206161943.GA3926@google.com>
 <CAN8TOE9SM1X_rQCScE8hCZYrWVY9K-B_TM+Vvzx3tZQ2LoGxXw@mail.gmail.com>
 <20120213174445.GD12117@google.com>
 <CAN8TOE-hFvDs4mGeYVRBDyfbyg8t_7YXDintLeG1QHvMXhVh+A@mail.gmail.com>
 <20120215165706.GA24986@google.com>
 <4F3BF989.8060607@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3BF989.8060607@garzik.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Jeff.

On Wed, Feb 15, 2012 at 01:29:29PM -0500, Jeff Garzik wrote:
> A module parameter is not necessarily the best/only option.
> ahci_platform already has infrastructure set up to deal with
> platform-specific quirks.  An internal flag seems more appropriate
> to enable automatic handling of this on the specific platforms where
> it applies (plus the revert Tejun has already mentioned).

The problem is that there's no way to identify the controller in
question, so we can't do this automatically, so might just as well do
it in the simplest way for now.  :(

Thanks.

-- 
tejun
