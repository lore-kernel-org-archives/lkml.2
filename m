Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2FILRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 07:17:55 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:48732 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab2FILRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 07:17:53 -0400
Date: Sat, 9 Jun 2012 07:17:47 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: writeback: bad unlock balance detected in 3.5-rc1
Message-ID: <20120609111747.GA21259@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Fengguang Wu <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <E1Sd0IP-0005nh-AJ@tytso-glaptop.cam.corp.google.com>
 <20120608150736.GF21080@quack.suse.cz>
 <20120608202840.GB1704@thunk.org>
 <20120608233728.GA7691@localhost>
 <20120609023804.GC14153@thunk.org>
 <20120609110731.GB14726@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120609110731.GB14726@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2012 at 07:07:31PM +0800, Fengguang Wu wrote:
> 
> 1MB memory? How do you manage to boot it? Recently I tried running a
> big fat kernel (with almost everything built in) that can easily OOM
> (at boot time, before swapon) even given 256MB memory...

Sorry, I was confused; it was megs.  That'll teach me to send e-mails
when I'm really tired.  I normally run with half that (to really
stress the paging/writeback systems), and I was thinking that a gig of
memory was way more than I normally use.  I think I was running into
some failures at 512m, which is why it got bumped to 1024.  I'll have
to try it again at 512 and see if it blows up or not.

     	      	       	     	    - Ted
