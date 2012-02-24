Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab2BXVag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 16:30:36 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:56326 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab2BXVaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 16:30:35 -0500
Date: Fri, 24 Feb 2012 16:30:27 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120224213027.GB15735@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Henrik Rydberg <rydberg@euromail.se>,
	Greg KH <gregkh@linuxfoundation.org>,
	Guenter Roeck <guenter.roeck@ericsson.com>,
	Jidong Xiao <jidong.xiao@gmail.com>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <1330103229.23014.130.camel@groeck-laptop>
 <20120224171752.GB9485@kroah.com>
 <20120224183423.GA23284@kroah.com>
 <20120224191535.GA4505@polaris.bitmath.org>
 <20120224192643.GB24120@kroah.com>
 <20120224201027.GA4859@polaris.bitmath.org>
 <20120224201655.GA5994@kroah.com>
 <20120224203715.GA4995@polaris.bitmath.org>
 <20120224205651.GA13333@kroah.com>
 <20120224212238.GA5178@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224212238.GA5178@polaris.bitmath.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 10:22:38PM +0100, Henrik Rydberg wrote:
> 
> Maintenance. Sure, as soon as an area grows too large for a single
> person, the current structure will ensure it divides so that the patch
> stream becomes manageable. We have already seen ample examples of
> that. But the overall structure of the kernel will become less and
> less manageable, and the likelihood of duplicates and maintenance
> problems will increase.

Not necessarily.  The primary area of growth has been hardware support
(i.e., drivers), and that scales quite well.

The main issue is the grown of intra-system interfaces, and you
haven't shown that this has happened in anything approaching the
levels where we need to worry.  If we add a new file system, like
btrfs, that doesn't add a whole new set of VFS interfaces, and it's
not like we need to worry about communication interfaces between btrfs
and ext4....

						- Ted
