Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab1D0PSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:18:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32797 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759360Ab1D0PR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:17:57 -0400
Date: Wed, 27 Apr 2011 08:07:38 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Oren Weil <oren.jer.weil@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, alan@linux.intel.com, david@woodhou.se
Subject: Re: [PATCH 7/8] staging/mei: AMT Watchdog
Message-ID: <20110427150738.GE24596@suse.de>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
 <1303900057-21694-8-git-send-email-oren.jer.weil@intel.com>
 <201104271553.01464.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104271553.01464.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 03:53:01PM +0200, Arnd Bergmann wrote:
> On Wednesday 27 April 2011, Oren Weil wrote:
> > 
> > code that open connection and invoke
> > heartbeats to the AMT Watchdog client/feature, if exists
> > 
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > Signed-off-by: Itzhak Tzeel-Krupp <itzhak.tzeel-krupp@intel.com>
> > Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
> 
> I still think this should be a regular watchdog driver using
> the drivers/watchdog user interface.

I agree, Oren, if you are going to insist on doing things this way, you
had better describe _why_ you are ignoring the existing kernel
interfaces provided.

thanks,

greg k-h
