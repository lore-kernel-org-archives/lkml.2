Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab2BXXOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 18:14:39 -0500
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:39464 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab2BXXOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 18:14:38 -0500
X-SENDER-IP: [85.230.168.211]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgCFAG8ZSE9V5qjTPGdsb2JhbABDiW2oGwOBBBkBAQEBNzSBcwEBBAE6HCMQCAMYLhQlChonh20JuAITikqCYgsDDw0CDxUFAwKFLQ4DDIMPYwSVOoVtjQQ
X-IronPort-AV: E=Sophos;i="4.73,478,1325458800"; 
   d="scan'208";a="54623882"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 25 Feb 2012 00:14:36 +0100
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120224231436.GA5815@polaris.bitmath.org>
References: <20120224201027.GA4859@polaris.bitmath.org>
 <20120224201655.GA5994@kroah.com>
 <20120224203715.GA4995@polaris.bitmath.org>
 <20120224205651.GA13333@kroah.com>
 <20120224212238.GA5178@polaris.bitmath.org>
 <20120224213027.GB15735@thunk.org>
 <20120224221459.GA5254@polaris.bitmath.org>
 <20120224222034.GB28198@kroah.com>
 <20120224224930.GA5684@polaris.bitmath.org>
 <20120224225437.GA15695@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224225437.GA15695@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 02:54:37PM -0800, Greg KH wrote:
> On Fri, Feb 24, 2012 at 11:49:30PM +0100, Henrik Rydberg wrote:
> > On Fri, Feb 24, 2012 at 02:20:34PM -0800, Greg KH wrote:
> > > On Fri, Feb 24, 2012 at 11:14:59PM +0100, Henrik Rydberg wrote:
> > > > The main issue that set me off has been sufficiently diluted in the
> > > > (selective) discussion so as to no longer make sense as a reply: At
> > > > some point, in-tree or out-of-tree will no longer be distinguishable,
> > > > and the question is if/when/why something would/should happen as a
> > > > consequence. A matter of politics, if you will. It seemed like an
> > > > honest question starting this thread, and I think it is fair to keep
> > > > it in mind as such.
> > > 
> > > If something happens to require such a change in the future, we will
> > > deal with it, at that time.  Remember the rule, "Linux is evolution, not
> > > intelligent design."
> > 
> > Who "we" is is exactly the point.
> 
> The kernel development community will handle it.

That's nice to hear, it seems like a fairly bright bunch.

> > For the not-so-important record, evolution does actually create
> > intelligent designs.
> 
> For some things yes, for others (like your tailbone), perhaps not :)

Oh no, that's where the matrix cord is plugged in. :-)

Cheers,
Henrik
