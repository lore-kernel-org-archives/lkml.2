Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab2BXWPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:15:19 -0500
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:48012 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab2BXWPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:15:17 -0500
X-SENDER-IP: [85.230.168.211]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aip4AAELSE9V5qjTPGdsb2JhbABDDolxqBuBBhkBAQEBNzSBcwEBBTocMwgDGC4UJQoaAYgctyITikqCH0MLAw8NAg8VBQMChS0OAwyDD2MElTqFbYxMOA
X-IronPort-AV: E=Sophos;i="4.73,478,1325458800"; 
   d="scan'208";a="274154985"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 24 Feb 2012 23:14:59 +0100
To: "Ted Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120224221459.GA5254@polaris.bitmath.org>
References: <20120224171752.GB9485@kroah.com>
 <20120224183423.GA23284@kroah.com>
 <20120224191535.GA4505@polaris.bitmath.org>
 <20120224192643.GB24120@kroah.com>
 <20120224201027.GA4859@polaris.bitmath.org>
 <20120224201655.GA5994@kroah.com>
 <20120224203715.GA4995@polaris.bitmath.org>
 <20120224205651.GA13333@kroah.com>
 <20120224212238.GA5178@polaris.bitmath.org>
 <20120224213027.GB15735@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224213027.GB15735@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 04:30:27PM -0500, Ted Ts'o wrote:
> On Fri, Feb 24, 2012 at 10:22:38PM +0100, Henrik Rydberg wrote:
> > 
> > Maintenance. Sure, as soon as an area grows too large for a single
> > person, the current structure will ensure it divides so that the patch
> > stream becomes manageable. We have already seen ample examples of
> > that. But the overall structure of the kernel will become less and
> > less manageable, and the likelihood of duplicates and maintenance
> > problems will increase.
> 
> Not necessarily.  The primary area of growth has been hardware support
> (i.e., drivers), and that scales quite well.
> 
> The main issue is the grown of intra-system interfaces, and you
> haven't shown that this has happened in anything approaching the
> levels where we need to worry.  If we add a new file system, like
> btrfs, that doesn't add a whole new set of VFS interfaces, and it's
> not like we need to worry about communication interfaces between btrfs
> and ext4....

True, and the emergent interface (vfs) is even accessible in
userspace, so all is good in that department for now. Conversely, you
have not shown that this can go on forever. ;-)

The main issue that set me off has been sufficiently diluted in the
(selective) discussion so as to no longer make sense as a reply: At
some point, in-tree or out-of-tree will no longer be distinguishable,
and the question is if/when/why something would/should happen as a
consequence. A matter of politics, if you will. It seemed like an
honest question starting this thread, and I think it is fair to keep
it in mind as such.

Thanks.
Henrik
