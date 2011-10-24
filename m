Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab1JXPor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 11:44:47 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34078 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719Ab1JXPoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 11:44:46 -0400
Date: Mon, 24 Oct 2011 08:44:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Greg KH <gregkh@suse.de>
Subject: Re: [RFC 3/4] lib: devres: add convenience function to remap a
 resource
Message-ID: <20111024154439.GC24914@google.com>
References: <1319445729-14841-1-git-send-email-w.sang@pengutronix.de>
 <1319445729-14841-4-git-send-email-w.sang@pengutronix.de>
 <20111024115612.GL8708@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024115612.GL8708@ponder.secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Grant.

On Mon, Oct 24, 2011 at 01:56:12PM +0200, Grant Likely wrote:
> > +/**
> > + * devm_resource_to_mapped_ptr - Check, request region, and ioremap resource
> 
> Kernel doc format should have '()' for functions is:

Simple Grepping gives me an order of magnitude more on the ones w/o
'()'.  Maybe it's better to change the rule at this point?

Thanks.

-- 
tejun
