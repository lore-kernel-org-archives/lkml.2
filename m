Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2GBOos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:44:48 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53944 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab2GBOor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:44:47 -0400
Date: Mon, 2 Jul 2012 10:44:44 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: ext4 blocks up
Message-ID: <20120702144444.GA18074@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
References: <1341231316.2979.11.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341231316.2979.11.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 03:15:16PM +0300, Artem Bityutskiy wrote:
> Hi Ted,
> 
> first of all I want to remind you about the sync_supers changes which
> you said you'd make sure get properly reviewed and tested for v3.5. But
> I am getting worried about missing also 3.5.
> 
> I wanted to re-send the patch-set, but I cannot test it because ext4
> blocks when I test it with xfstests.

Sorry, I've just been totally swamped this past couple of monthes;
work deadlines, plus a lot of other things that have been just keeping
me totally overloaded.

Can you tell me *which* xfstest this was blocking on?  I generally run
xfstests under KVM, on the console, which is nice because the xfstests
output gets interleaved with any kernel oops/softlock up messages.

Also, for the sort of changes you are doing using the check -g quick
is probably good enough, that will get you unblocked.

I don't recall anything going wrong with a -g auto run with a standard
4k block size, but I'll give it a try on my end and see what I get.

   	          	       	   	     	      - Ted
