Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab0EVOt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 10:49:57 -0400
Received: from kroah.org ([198.145.64.141]:54792 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab0EVOty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 10:49:54 -0400
Date: Sat, 22 May 2010 07:49:16 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: linux-next: build warning after merge of the final tree
 (Linus' tree related)
Message-ID: <20100522144916.GA4269@kroah.com>
References: <20100522164644.43846a3c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100522164644.43846a3c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 04:46:44PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the final tree, today's linux-next build (powerpc
> allnoconfig) produced this warning:
> 
> lib/kobject_uevent.c:86: warning: 'kobj_bcast_filter' defined but not used
> 
> Introduced by commit 5f71a29629b4717445f8b7f5fb8f50c2d262b68e ("kobj:
> Send hotplug events in the proper namespace") from Linus' tree.

Thanks, someone already sent me a patch for this and I'll queue it up
next week.

greg k-h
