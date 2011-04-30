Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab1D3Flb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 01:41:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:40793 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab1D3Fla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 01:41:30 -0400
Date: Fri, 29 Apr 2011 22:42:23 -0700
From: Greg KH <gregkh@suse.de>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Allow setting of number of raw devices as a module parameter
Message-ID: <20110430054223.GA18910@suse.de>
References: <1304029469-19672-1-git-send-email-jack@suse.cz>
 <20110429162817.2eb26efb.akpm@linux-foundation.org>
 <20110430000704.GA3443@suse.de>
 <20110430050951.GA16557@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430050951.GA16557@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 01:09:51AM -0400, Dave Jones wrote:
> On Fri, Apr 29, 2011 at 05:07:04PM -0700, Greg KH wrote:
>  > On Fri, Apr 29, 2011 at 04:28:17PM -0700, Andrew Morton wrote:
>  > > On Fri, 29 Apr 2011 00:24:29 +0200
>  > > Jan Kara <jack@suse.cz> wrote:
>  > > 
>  > > > Allow setting of maximal number of raw devices as a module parameter. This
>  > > > requires changing of static array into a vmalloced one (the array is going to
>  > > > be too large for kmalloc).
>  > > > 
>  > > 
>  > > Changelog failed to describe why the patch is needed.  Lacking that
>  > > information, we have no reason to apply it.
>  > 
>  > Good point, how about:
>  > 	People like running their machines with thousands of raw
>  > 	devices, yet distros don't want to take up that much memory for
>  > 	all users.  Provide a way for everyone to be happy without
>  > 	forcing the module to be rebuilt by providing the ability to
>  > 	specify the number of raw devices as a module parameter option.
> 
> I remember when this was made a config option, thinking "8192 raw devices?
> who would need that many?".  I have to wonder just how someone manages
> a system with an insane number of these devices.

Think of a very large database benchmark with many thousands of "disks"
that are used to get very fast throughput numbers...

As for how they manage them, there's tools for that that companies are
very happy to sell you to make it easier (IBM, CA, etc.)

Bizarre, yes, unrealistic, no :(

thanks,

greg k-h
