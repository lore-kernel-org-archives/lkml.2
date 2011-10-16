Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab1JPP7B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 11:59:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab1JPP67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 11:58:59 -0400
Date: Sun, 16 Oct 2011 08:55:17 -0700
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] PCI, sys: only create rescan under
 /sys/.../pci/devices/... for pci bridges
Message-ID: <20111016155517.GA6421@suse.de>
References: <4E9A3092.4080309@oracle.com>
 <4E9A3436.3010704@oracle.com>
 <20111016023943.GA3787@suse.de>
 <4E9A6CCB.4060101@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9A6CCB.4060101@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 10:34:03PM -0700, Yinghai Lu wrote:
> On 10/15/2011 07:39 PM, Greg KH wrote:
> 
> > 
> > No, we already have a way to do this, this is not acceptable, sorry.
> > 
> 
> 
> hope this one is ok...

Nope, not at all, don't use #ifdef in .c files.

Again, we have a way to do this, built into sysfs, that can dynamically
know to add or not add, attributes when they are registered with the
system.

Is there some reason you want to create a new way to do this, or just
ignore it by using another forbidden thing (i.e. #ifdefs)?

confused,

greg k-h
