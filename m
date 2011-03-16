Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab1CPHVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 03:21:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57247 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab1CPHV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 03:21:29 -0400
Date: Wed, 16 Mar 2011 07:21:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS - the first pile
Message-ID: <20110316072123.GR22723@ZenIV.linux.org.uk>
References: <20110315213248.GL22723@ZenIV.linux.org.uk>
 <20110316061917.GA30195@dastard>
 <20110316065103.GP22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110316065103.GP22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 06:51:03AM +0000, Al Viro wrote:
> On Wed, Mar 16, 2011 at 05:19:17PM +1100, Dave Chinner wrote:
> > I think there's something not quite right in this tree. xfstests 005
> > (nested symlink test) fails on both ext4 and XFS with the following:
> 
> Yeah...  Brown paperbag time - it's actually a missing piece that
> got glued with a commit a bit later in queue ;-/  I've dropped it
> into for-linus for the morning push; in the meanwhile, the patch is
> below.

BTW, you want to update 005 in there - we are back to correct "maximum
is 40 symlinks total, 8 levels on nesting" for all syscalls.  Add the
41st symlink to your chain in testcase ;-)
