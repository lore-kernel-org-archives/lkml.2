Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab2BVVUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 16:20:13 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46694 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab2BVVUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 16:20:11 -0500
Date: Wed, 22 Feb 2012 13:19:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org, Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
Message-ID: <20120222211928.GA4448@kroah.com>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 12:54:58PM -0800, Linus Torvalds wrote:
> 
> This is a reasonably minimal backport of the i387 state save/restore bug.
> 
> A few of the commits are just minimal "make it easier to backport" commits 
> that don't necessarily fix anything on their own.  And a few of the others 
> are combinations of what is two commits in the development tree, because 
> it turned out to be easier and cleaner that way.
> 
> The last one is the one that fixes the x86-32 bug, but the preemption 
> fixes are real fixes too, although they are probably not something that 
> anybody has necessarily ever hit in reality because the race window is so 
> small.  Even so, if the fix itself isn't that important, the "make it 
> easier to backport the main one" would still be a big argument for it.
> 
> I *really* hope that the people who could reproduce this bug will test the 
> back-port series too, since I never actually saw the bug personally to 
> begin with. And again, big thanks to Raphael who helped pinpoint and debug 
> this.

Thanks for doing the backport.  Any ideas on how far back this problem
goes?

thanks,

greg k-h
