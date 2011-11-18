Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab1KRTL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:11:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab1KRTL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:11:57 -0500
Date: Fri, 18 Nov 2011 11:10:33 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation for sysfs attributes for 3.3 (xen related)
Message-ID: <20111118191033.GA24889@suse.de>
References: <1321640393-19708-1-git-send-email-konrad.wilk@oracle.com>
 <4EC6A2D6.10702@xenotime.net>
 <20111118183313.GA7417@suse.de>
 <4EC6AADA.2040805@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC6AADA.2040805@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 10:58:34AM -0800, Randy Dunlap wrote:
> On 11/18/2011 10:33 AM, Greg KH wrote:
> > On Fri, Nov 18, 2011 at 10:24:22AM -0800, Randy Dunlap wrote:
> >> On 11/18/2011 10:19 AM, Konrad Rzeszutek Wilk wrote:
> >>> Please accept the following two patches that describe the
> >>> SysFS of some of the Xen drivers. Thank you.
> >>>
> >>> David Vrabel (2):
> >>>       xen: document balloon driver sysfs files
> >>>       xen: document backend sysfs files
> >>>
> >>>  Documentation/ABI/stable/sysfs-bus-xen-backend     |   75 +++++++++++++++++++
> >>>  .../ABI/stable/sysfs-devices-system-xen_memory     |   77 ++++++++++++++++++++
> >>>  2 files changed, 152 insertions(+), 0 deletions(-)
> >>
> >> Hey,
> >>
> >> Documentation/ABI/ patches should go to GregKH.
> > 
> > Really?  I'm now in charge of the kernel ABI?
> 
> Well, you are the person who usually tells people that they need
> to provide Documentation/ABI/ patches for sysfs files AFAICT.

Yes, because that's a requirement of the whole kernel development
process, not because I'm the maintainer of Documentation/ABI.

Everyone should be reminding people of doing this, not just me.

thanks,

greg k-h
