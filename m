Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2FMVpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:45:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57294 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab2FMVpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:45:13 -0400
Date: Wed, 13 Jun 2012 14:45:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: misc: mei: fixes for 3.5
Message-ID: <20120613214509.GA9051@kroah.com>
References: <1338298752-15445-1-git-send-email-tomas.winkler@intel.com>
 <20120613203729.GA11326@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B12A780@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B12A780@HASMSX103.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 09:09:14PM +0000, Winkler, Tomas wrote:
> 
> 
> > > Hi Greg,
> > > please consider this batch for queuing into 3.5 1. patch 2/4 bug in
> > > probe: visible only after merging with the trunk 2. patch 3/4 fixes
> > > kernel oops that was revealed when probe failed 3. patch 4/4 is
> > > regression fix and should be merged also to stable 3.4 4. patch 1/4 is
> > > a minor documentation fix
> > 
> > Grammer fixes are not ok for 3.5 at this point in time, sorry.  I'll queue up the
> > other 3 though.
> 
> Thanks reasonable. 
> 
> Please consider also  this two:
> 
> This one is one more fix connected to the same issue as the 3 patches. (From Samuel Oritz) 
> http://marc.info/?l=linux-kernel&m=133940653731271&w=2
> 
> This one is just adding a flag to WATCHDOG devices that was only possible after merging the watchdog tree into 3.5-rc1. 
> This one is not must so I leave it for you to decide. 
> http://marc.info/?l=linux-kernel&m=133940653831272&w=2

Yes, they are still in my queue, I'll get to them...

greg k-h
