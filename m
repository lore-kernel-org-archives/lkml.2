Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab1LORVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:21:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:23607 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759238Ab1LORVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:21:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="96603499"
Date: Thu, 15 Dec 2011 18:25:45 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: myungjoo.ham@samsung.com, =?utf-8?B?6rmA64+Z6re8?= <dg77.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] misc: add driver support for MAX8997 MUIC
Message-ID: <20111215172545.GB20840@sortiz-mobl>
References: <33434703.581501323909131767.JavaMail.weblogic@epml15>
 <201112151534.01995.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112151534.01995.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, Dec 15, 2011 at 03:34:01PM +0000, Arnd Bergmann wrote:
> On Thursday 15 December 2011, MyungJoo Ham wrote:
> > Arnd Bergmann wrote:
> > > On Monday 12 December 2011, Samuel Ortiz wrote:
> > > The part that is not clear to me is how this new driver fits in
> > > with the first fsa9480 driver and the currently discussed extcon
> > > subsystem, apparently all written by the same team at Samsung.
> > > Is this misc driver still useful when the extcon framework gets
> > > merged?
> > 
> > When extcom gets merged, this driver should be updated. It looks like allowing
> > the interrupt handler to update extcon state would be enough. Bascially, this
> > is all this driver is required for extcon to work. (and the prvious author of
> > extcon--"extended" switch class at that time--was the author of this patch.)
> > 
> > Anyway, this patch has just told me that I'll need to add more sysfs entries
> > for extcon to show the list of cable names and/or to show the status for each
> > of them, soon or later.
> 
> I think it would be better not to merge this driver until the user interface
> in the extcon framework has been finalized. I don't mind the driver, but I
> want to prevent user interfaces from appearing in the kernel that we
> intend to change anyway.
> 
> How about dropping the driver from the mfd tree, and adding it into the
> extcon series for the next posting?
Sounds good to me, I'll drop it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
