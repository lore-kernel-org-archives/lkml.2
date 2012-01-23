Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab2AWVDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:03:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab2AWVDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:03:34 -0500
Date: Mon, 23 Jan 2012 16:03:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123210327.GO25986@redhat.com>
References: <20120123155216.GF25986@redhat.com>
 <20120123155745.GD12652@google.com>
 <20120123161042.GG25986@redhat.com>
 <20120123161619.GE12652@google.com>
 <20120123162553.GI25986@redhat.com>
 <20120123171049.GH12652@google.com>
 <20120123182745.GK25986@redhat.com>
 <20120123184336.GI12652@google.com>
 <20120123204352.GB21822@tango.0pointer.de>
 <20120123204757.GM12652@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123204757.GM12652@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 12:47:57PM -0800, Tejun Heo wrote:
> Hello, Lennart.
> 
> On Mon, Jan 23, 2012 at 09:43:52PM +0100, Lennart Poettering wrote:
> > I didn't really follow the whole discussion here, but if this is about
> > adjusting parameters of a block device as the block device shows up this
> > must necessarily happen in an udev rule (and not in a daemon watching
> > block devices using libudev), since you most likely need the
> > synchronicity: i.e. you want to avoid that normal (libudev-using)
> > userspace code ever sees the device before those params are written to
> > the device. A daemon asynchronously watching the devices with libudev
> > for adjusting such tunables is necessarily racy.
> 
> Yeap, this needs to be synchronous so that it's configured before the
> rest of system notices the device.  Vivek, can you please ask the
> tuned guys to take a look?

Sure I will. Thanks.

Vivek
