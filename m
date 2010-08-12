Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab0HLAYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:24:04 -0400
Received: from kroah.org ([198.145.64.141]:40051 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758663Ab0HLAYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:24:00 -0400
Date: Wed, 11 Aug 2010 17:23:56 -0700
From: Greg KH <greg@kroah.com>
To: Davidlohr Bueso <dave@gnu.org>
Cc: mochel@osdl.org, mamurph@cs.clemson.edu,
        LKML <linux-kernel@vger.kernel.org>,
        linux-doc <linux-doc@vger.kernel.org>
Subject: Re: Outdated sysfs.txt document?
Message-ID: <20100812002356.GA12214@kroah.com>
References: <1281564321.1934.5.camel@cowboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281564321.1934.5.camel@cowboy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 06:05:21PM -0400, Davidlohr Bueso wrote:
> Hi,

Any reason you didn't send this to the current sysfs maintainer?

> I have been going through Documentation/filesystems/sysfs.txt, and
> noticed what I believe to be either outdated or incomplete:
> 
> The "Top Level Directory Layout" mentions
> block/
> bus/
> class/
> dev/
> devices/
> firmware/
> net/
> fs/
> 
> We seem to be missing kernel, power, hypervisor, module, etc. 
> 
> dave@cowboy:~$ ls /sys/
> block  class  devices   fs          kernel  power
> bus    dev    firmware  hypervisor  module
> 
> I am preparing a patch to complete this, but could someone confirm first
> that this is actually what is meant.

It would be nice to have it match up to reality, Documentation usually
lags.

thanks,

greg k-h
