Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876Ab2BJXQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:16:40 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:36393 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932560Ab2BJXQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 18:16:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEFAE6kNU95LD+bgWdsb2JhbABDrnd7IwEBFiYngXIBAQU6HCMQCAMOCi4UJQMhE7p9E4sIKDAQAgQHAgcHCwQBCwENAQQRA4NkBQITAQENAQIBCgEEBQODVASVL5J5
Date: Sat, 11 Feb 2012 10:16:33 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Eric Sandeen <sandeen@sandeen.net>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        mpatocka@redhat.com
Subject: Re: [PATCH 1/2] vfs: Provide function to get superblock and wait for
 it to thaw
Message-ID: <20120210231633.GH12836@dastard>
References: <1328654267-18855-1-git-send-email-jack@suse.cz>
 <1328654267-18855-2-git-send-email-jack@suse.cz>
 <20120208232049.GC7479@dastard>
 <20120208232705.GF1696@quack.suse.cz>
 <20120208234703.GG1696@quack.suse.cz>
 <4F33F640.7040508@sandeen.net>
 <20120210094858.GC10509@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210094858.GC10509@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 10:48:58AM +0100, Jan Kara wrote:
> On Thu 09-02-12 10:37:20, Eric Sandeen wrote:
> > would "wait_for_thaw" vs. "thaw" be any clearer?  Nitpicky I guess but the
> > meaning of "thawed" isn't immediately clear here.  If it's already thawed?  If
> > we want to wait for it it to be thawed?  You can figure it out from the callers
> > but maybe a comment or a different name might help.  No big deal.
>   How about "wait_thaw". That should be explicit enough...

IMO, wait_for_thaw is much easier to read (i.e. better english ;) and
hence the code documents itself better. There's no reason to skimp
on characters here - it's not a heavily used variable....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
