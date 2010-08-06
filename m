Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965037Ab0HFSiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:38:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:36223 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965028Ab0HFSiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:38:02 -0400
Date: Fri, 6 Aug 2010 11:37:53 -0700
From: Greg KH <gregkh@suse.de>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATCH: West Bridge Driver Kernel Support linux-2.6.35
Message-ID: <20100806183753.GA23230@suse.de>
References: <B29B739A156A44E08224A57B8B920064@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B29B739A156A44E08224A57B8B920064@stanford.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 11:24:39AM -0700, David Cross wrote:
> Binary files linux-2.6-35-vanilla/arch/arm/boot/compressed/piggy.gzip and
> linux-2.6-35_incl_sdk/arch/arm/boot/compressed/piggy.gzip differ

Your patch contains a bunch of stuff you don't need, like this.

> diff -uprN -X linux-2.6-35-vanilla/Documentation/dontdiff
> linux-2.6-35-vanilla/block/modules.builtin
> linux-2.6-35_incl_sdk/block/modules.builtin

And this.

> diff -uprN -X linux-2.6-35-vanilla/Documentation/dontdiff
> linux-2.6-35-vanilla/drivers/connector/modules.builtin
> linux-2.6-35_incl_sdk/drivers/connector/modules.builtin

And so on.

You should fix this up before resending.

It looks like no one has updated the dontdiff file in a while, now that
we are all using git :)

thanks,

greg k-h
