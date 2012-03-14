Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030838Ab2CNNp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 09:45:27 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:48337 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964984Ab2CNNpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 09:45:25 -0400
Date: Wed, 14 Mar 2012 09:45:20 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Suggest pr_<level> over printk(KERN_<LEVEL>
Message-ID: <20120314134520.GA26524@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@shadowen.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120314003157.GA15379@thunk.org>
 <1331686026.24613.6.camel@joe2Laptop>
 <20120314010701.GB15379@thunk.org>
 <1331687831.27389.2.camel@joe2Laptop>
 <20120314021938.GD15379@thunk.org>
 <1331692311.27389.27.camel@joe2Laptop>
 <20120314024104.GE15379@thunk.org>
 <1331694074.27389.42.camel@joe2Laptop>
 <20120314123429.GG15379@thunk.org>
 <1331730336.27389.70.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331730336.27389.70.camel@joe2Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 06:05:36AM -0700, Joe Perches wrote:
> Patchwork queues are pretty useless when patches entered
> do not have their status updated for long periods.
> 
> The patch I sent in August 2011 shows "new" rather than
> have an appropriate status.
> 
> If you actually use patchwork, though it seems you don't,
> I think you should just mark every patch that's new as
> rejected and start over.

I use it, but not in the way you think I should be using it.  Your not
getting to your will on other kernel developers is what this thread is
all all about, ultimately.

I don't get to work on ext4 full time, and so every minute I put on it
has to not a be a waste of time.  This includes updating status
messages for patches that aren't obviously not applicable, or
superceded, but rather something that I might get to look at later.

	    	       		      	      - Ted
