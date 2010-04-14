Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab0DNQ3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:29:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:59600 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274Ab0DNQ3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:29:23 -0400
Date: Wed, 14 Apr 2010 09:18:51 -0700
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, wey-yi.w.guy@intel.com,
       reinette.chatre@intel.com, shanyu.zhao@intel.com, stable@kernel.org
Subject: Re: patch
	iwlwifi-counting-number-of-tfds-can-be-free-for-4965.patch added to
	2.6.33-stable tree
Message-ID: <20100414161851.GC5720@suse.de>
References: <12705808611488@kroah.org> <201004110116.10564.s.L-H@gmx.de> <20100410232116.GA8360@suse.de> <201004141210.08504.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004141210.08504.s.L-H@gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 12:09:50PM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> Hi
> 
> On Wednesday 14 April 2010, Greg KH wrote:
> > On Sun, Apr 11, 2010 at 01:16:06AM +0200, Stefan Lippers-Hollmann wrote:
> > > Hi
> > > 
> > > On Sunday 11 April 2010, gregkh@suse.de wrote:
> > > > This is a note to let you know that we have just queued up the patch titled
> > > > 
> > > >     Subject: iwlwifi: counting number of tfds can be free for 4965
> > > > 
> > > > to the 2.6.33-stable tree.  Its filename is
> > > > 
> > > >     iwlwifi-counting-number-of-tfds-can-be-free-for-4965.patch
> > > > 
> > > > A git repo of this tree can be found at 
> > > >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > > > 
> > > > From be6b38bcb175613f239e0b302607db346472c6b6 Mon Sep 17 00:00:00 2001
> > > > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > > > Date: Thu, 18 Mar 2010 09:05:00 -0700
> > > > Subject: iwlwifi: counting number of tfds can be free for 4965
> > > > 
> > > > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > > > 
> > > > commit be6b38bcb175613f239e0b302607db346472c6b6 upstream.
> > > > 
> > > > Forget one hunk in 4965 during "iwlwifi: error checking for number of tfds
> > > > in queue" patch.
> > > [...]
> > > 
> > > With this patch applied as part of the current -stable queue for 2.6.33, 
> > > I've gotten feedback from two different IPW4965 users on amd64 and i386 
> > > architectures that they're getting a kernel panic while booting:
> > 
> > Yes, there is a follow-up patch that just went to Linus to fix this
> > issue.  I should be picking it up in a day or so.
> [...]
> 
> Thanks, the updated queue-2.6.33 (which means likely iwlwifi-need-check-for-
> valid-qos-packet-before-free.patch) indeed fixes the problem for both 
> users.

Wonderful, thanks for verifying this, I appreciate it.

greg k-h
