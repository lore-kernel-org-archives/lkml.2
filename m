Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab2GBSOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:14:48 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:54029 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab2GBSOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:14:47 -0400
Date: Mon, 2 Jul 2012 14:14:42 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Eric Sandeen <sandeen@redhat.com>, Artem Bityutskiy <dedekind1@gmail.com>,
        Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: ext4 blocks up
Message-ID: <20120702181442.GC5795@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
References: <1341231316.2979.11.camel@sauron.fi.intel.com>
 <20120702144444.GA18074@thunk.org>
 <1341240862.2979.23.camel@sauron.fi.intel.com>
 <20120702151442.GB18074@thunk.org>
 <20120702164548.GD18074@thunk.org>
 <4FF1D22D.2070804@redhat.com>
 <20120702173104.GK6679@quack.suse.cz>
 <20120702174342.GA5795@thunk.org>
 <20120702175341.GN6679@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120702175341.GN6679@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 07:53:41PM +0200, Jan Kara wrote:
> 
> > Can you send me a pointer to your patches?  Is this something that Al
>   http://www.spinics.net/lists/kernel/msg1355763.html

Ah, right.  OK, I didn't realize until I took a closer look that
xfstests #68 was testing file system freezes while running fsstress.

So Artem, what I'd suggest doing for now is to simply comment out test
#68 from your xfstests's group file and just avoid running that test
until this gets sorted. I simply hadn't noticed since for most of my
quick checks I tend to use -g quick, and -g auto more rarely (i.e.,
before I push changes to Linus, and every so often during the dev
cycle), and test #68 isn't run for -g quick, and it's only failing
about 5-10% of the time in my test configuration.

	      	       	   	      	   - Ted
