Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617Ab2CNBHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 21:07:09 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57731 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760233Ab2CNBHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 21:07:06 -0400
Date: Tue, 13 Mar 2012 21:07:01 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Suggest pr_<level> over printk(KERN_<LEVEL>
Message-ID: <20120314010701.GB15379@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@shadowen.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1330661602.1939.13.camel@joe2Laptop>
 <1330666534.1939.19.camel@joe2Laptop>
 <1330667673.1939.22.camel@joe2Laptop>
 <1331619783.7100.8.camel@joe2Laptop>
 <20120313120514.GA17538@thunk.org>
 <20120313145517.f4fcae46.akpm@linux-foundation.org>
 <20120313220144.GD11969@thunk.org>
 <20120313150316.6ae19b95.akpm@linux-foundation.org>
 <20120314003157.GA15379@thunk.org>
 <1331686026.24613.6.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331686026.24613.6.camel@joe2Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 05:47:06PM -0700, Joe Perches wrote:
> Or add an I: line to MAINTAINERS
> 
> though perhaps it's better to agree on a style.
> 
> I did send a few fixes and a style consolidation patch
> for ext4 with no reply awhile ago:
> 
> https://lkml.org/lkml/2011/8/2/41

You combined a huge number of changes into a single patch, and as far
as I was concerned the value it added Just Wasn't Worth It.  It adds
noise which causes other patches, which add real value, not to apply
cleanly.

I routinely ignore such patches because I have a limited amount of
time, and as far as I'm concerned they mainly make my life harder.

Looking more closely, there are a few changes in there that I'd
accept, but it was burried amongst so much other junk that if it's all
or nothing, it would be nothing.  Funny that someone who is an expert
in style things neglected something **far** more important ---
segregate logical changes in separate commits; don't collapse
everything into a single patch, which makes it hard to review.

      	     	    		  - Ted
