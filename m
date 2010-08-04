Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab0HDTql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:46:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:37994 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758668Ab0HDTqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:46:36 -0400
Date: Wed, 4 Aug 2010 12:46:17 -0700
From: Greg KH <gregkh@suse.de>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        tytso@mit.edu
Subject: Re: new gerneric kfifo API
Message-ID: <20100804194617.GA30773@suse.de>
References: <201005132135.o4DLZ9WI021613@imap1.linux-foundation.org>
 <1280905854.8441.3.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280905854.8441.3.camel@wall-e.seibold.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 09:10:54AM +0200, Stefani Seibold wrote:
> Hi,
> 
> once again. Kernel 2.6.35 is out and i want to know if there is play plan to
> merge the generic kfifo API. All complains was fixed, so there is no
> reason to shift the merge again. Please gibe me a short answer.

These have been in the -mm tree for a few major kernel releases now,
right?  And they are API safe, and only change the internals, right?

If so, I see no objection to merging them now, especially as you will be
around to fix up any problems that people have, right?  :)

thanks,

greg k-h
