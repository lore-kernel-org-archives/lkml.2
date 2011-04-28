Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab1D1Nkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:40:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759516Ab1D1Nk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:40:28 -0400
Date: Thu, 28 Apr 2011 06:38:30 -0700
From: Greg KH <gregkh@suse.de>
To: "Weil, Oren jer" <oren.jer.weil@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "david@woodhou.se" <david@woodhou.se>
Subject: Re: [PATCH 7/8] staging/mei: AMT Watchdog
Message-ID: <20110428133830.GB4861@suse.de>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
 <1303900057-21694-8-git-send-email-oren.jer.weil@intel.com>
 <201104271553.01464.arnd@arndb.de>
 <20110427150738.GE24596@suse.de>
 <F28B59AD52D84B479DCA469824475335065AF92EC7@hasmsx503.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F28B59AD52D84B479DCA469824475335065AF92EC7@hasmsx503.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 08:51:41AM +0300, Weil, Oren jer wrote:
> >On Wed, Apr 27, 2011 at 03:53:01PM +0200, Arnd Bergmann wrote:
> >> I still think this should be a regular watchdog driver using the
> >> drivers/watchdog user interface.
> >
> >I agree, Oren, if you are going to insist on doing things this way, you had
> >better describe _why_ you are ignoring the existing kernel interfaces
> >provided.
> 
> we are not going to ignore the existing interfaces, it is one of our items
> in the TODO list.

Like I stated earlier, there was no TODO list in your patch, so how
could we know this?  :)

> You can see the we move all of the Watchdog code to a single file so it
> would easy to us to take it later to other driver.
> Another Item on our TODO list is to expose Kernel function that equivalent
> to user interface so kernel clients can access FW features/clients.

Nice, but again, how could we know this?

thanks,

greg k-h
