Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab0CaVL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:11:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758176Ab0CaVLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:11:53 -0400
Date: Wed, 31 Mar 2010 14:12:04 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, stable-review@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [087/116] PCI quirk: RS780/RS880: work around missing MSI
	initialization
Message-ID: <20100331211204.GB19139@suse.de>
References: <20100330225656.136257690@linux.site> <alpine.LFD.2.00.1003301711330.3707@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003301711330.3707@i5.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 05:13:13PM -0700, Linus Torvalds wrote:
> 
> 
> 
> On Tue, 30 Mar 2010, Greg KH wrote:
> >
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Clemens Ladisch <clemens@ladisch.de>
> > 
> > commit a5ee4eb75413c145334c30e43f1af9875dad6fd7 upstream.
> 
> NAK. 
> 
> Rafael reports this causes a regression. I don't think we know why, but 
> more importantly, that definitely means this is not stable material.

Thanks, I've now dropped this from the .32 and .33 queues.

greg k-h
