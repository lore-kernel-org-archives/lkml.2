Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab2BXURN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:17:13 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37502 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab2BXURL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:17:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.73.103 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 24 Feb 2012 12:16:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120224201655.GA5994@kroah.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
 <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
 <20120224153811.GA16535@kroah.com>
 <1330103229.23014.130.camel@groeck-laptop>
 <20120224171752.GB9485@kroah.com>
 <20120224183423.GA23284@kroah.com>
 <20120224191535.GA4505@polaris.bitmath.org>
 <20120224192643.GB24120@kroah.com>
 <20120224201027.GA4859@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224201027.GA4859@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 09:10:27PM +0100, Henrik Rydberg wrote:
> I am not complaining about the kernel and its driver structure - on
> the contrary. I do, however, see a reason why constructing lower-level
> interfaces to userspace may be of benefit. The kernel is growing
> tremendously fast. Sooner or later, parts of the present driver
> responsibility will have to be split into smaller chunks. Why not
> place those chunks outside the kernel itself?

I fail to understand why you think the growth of the kernel will require
drivers to be split into chunks in the future.  Are we somehow growing
faster than is required / needed / wanted and outstripping the size of
what we are allowed to take up on machines?

greg k-h
