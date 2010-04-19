Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0DSQ02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 12:26:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180Ab0DSQ00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 12:26:26 -0400
Date: Mon, 19 Apr 2010 09:15:15 -0700
From: Greg KH <gregkh@suse.de>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       andi@firstfloor.org, alan@lxorguk.ukuu.org.uk, tytso@mit.edu,
       iws@ovro.caltech.edu
Subject: Re: [PATCH 2/4] remove the old non generic API
Message-ID: <20100419161515.GA17949@suse.de>
References: <1271624718-8256-1-git-send-email-stefani@seibold.net>
 <1271624718-8256-3-git-send-email-stefani@seibold.net>
 <20100419152856.GC11553@suse.de>
 <1271691184.12238.2.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271691184.12238.2.camel@wall-e.seibold.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 05:33:04PM +0200, Stefani Seibold wrote:
> Am Montag, den 19.04.2010, 08:28 -0700 schrieb Greg KH:
> > On Sun, Apr 18, 2010 at 11:05:16PM +0200, stefani@seibold.net wrote:
> > > From: Stefani Seibold <stefani@seibold.net>
> > > 
> > > This patch simple remove the whole kfifo.c and kfifo.h files. The next
> > > patch will replace it with the new generic kfifo API.
> > 
> > But you just broke the kernel build at this point in the patch sequence,
> > which is not allowed :(
> > 
> 
> I know, but the only way is to merge the patch 2 and 3 together which
> results in a very large and unreadable patch.
> 
> If desired i will do this...

Or you can rename files, or do all sorts of other things instead of
breaking the build, which again, is not allowed, so don't do it :)

thanks,

greg k-h
