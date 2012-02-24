Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab2BXUhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:37:22 -0500
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:50109 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173Ab2BXUhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:37:21 -0500
X-SENDER-IP: [85.230.168.211]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiiIALz0R09V5qjTPGdsb2JhbABDiW2oFwOBBBkBAQEBNzSBcwEBBTocERIQCAMYLhQlChqIHbgCE4pKgh8PFR8LAw8NAg8VBQMChS0OAwyDD2MElTqFbY0E
X-IronPort-AV: E=Sophos;i="4.73,477,1325458800"; 
   d="scan'208";a="274130685"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 24 Feb 2012 21:37:15 +0100
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120224203715.GA4995@polaris.bitmath.org>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
 <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
 <20120224153811.GA16535@kroah.com>
 <1330103229.23014.130.camel@groeck-laptop>
 <20120224171752.GB9485@kroah.com>
 <20120224183423.GA23284@kroah.com>
 <20120224191535.GA4505@polaris.bitmath.org>
 <20120224192643.GB24120@kroah.com>
 <20120224201027.GA4859@polaris.bitmath.org>
 <20120224201655.GA5994@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224201655.GA5994@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 12:16:55PM -0800, Greg KH wrote:
> On Fri, Feb 24, 2012 at 09:10:27PM +0100, Henrik Rydberg wrote:
> > I am not complaining about the kernel and its driver structure - on
> > the contrary. I do, however, see a reason why constructing lower-level
> > interfaces to userspace may be of benefit. The kernel is growing
> > tremendously fast. Sooner or later, parts of the present driver
> > responsibility will have to be split into smaller chunks. Why not
> > place those chunks outside the kernel itself?
> 
> I fail to understand why you think the growth of the kernel will require
> drivers to be split into chunks in the future.  Are we somehow growing
> faster than is required / needed / wanted and outstripping the size of
> what we are allowed to take up on machines?

How long can one grow and still claim to _be_ a kernel? The current
(arbitrary) split between kernel and userland was made a long time
ago. For a number of reasons, of course, but not least out of
convenience. Projecting the current kernel growth ten years into the
future, will there still not be another (arbitrary) convenient split?

Even so, the main point was not whether a secondary split may or may
not happen, but what will happen to the quality of the total system
when/if that happens. I doubt the fate of userland drivers would be so
heatedly discussed if everyone believed that work would be carried out
with the same quality currently found in the kernel.

Henrik
