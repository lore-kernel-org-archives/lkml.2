Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab1DCO2c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 10:28:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab1DCO2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 10:28:31 -0400
Date: Sun, 3 Apr 2011 07:15:09 -0700
From: Greg KH <gregkh@suse.de>
To: bookjovi@gmail.com
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: update file header info correctly
Message-ID: <20110403141509.GA27154@suse.de>
References: <1301455753-2866-1-git-send-email-bookjovi@gmail.com>
 <20110403100959.GA4834@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110403100959.GA4834@p183.telecom.by>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 03, 2011 at 01:09:59PM +0300, Alexey Dobriyan wrote:
> On Tue, Mar 29, 2011 at 11:29:13PM -0400, bookjovi@gmail.com wrote:
> > From: Jovi Zhang <bookjovi@gmail.com>
> > 
> > After some files changed location from drivers/char to driver/tty,
> > file header info also need to update
> 
> They should be _removed_ exactly to avoid this kind of patches.

I agree, please remove these lines.

thanks,

greg k-h
