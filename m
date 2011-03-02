Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab1CBUl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 15:41:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:43914 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab1CBUl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 15:41:26 -0500
Date: Wed, 2 Mar 2011 15:42:02 -0500
From: Greg KH <gregkh@suse.de>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.32.30
Message-ID: <20110302204202.GB19022@suse.de>
References: <20110302145828.GA4999@kroah.com>
 <4D6E7548.807@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6E7548.807@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 05:50:16PM +0100, Stefan Bader wrote:
> > FUJITA Tomonori (1):
> >       swiotlb: fix wrong panic
> >
> 
> This one breaks compilation of 64bit for me as swiotlb_tbl_unmap_single() does
> not exist. It does not look like it is a simple single patch that would get it
> back to 2.6.32.

I don't understand.  Is this patch somehow broken?  Is there an
additional patch I need to apply to fix the build issue?  I need more
information here.

thanks,

greg k-h
