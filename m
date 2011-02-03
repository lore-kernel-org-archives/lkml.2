Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1BCWUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 17:20:52 -0500
Received: from kroah.org ([198.145.64.141]:59587 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138Ab1BCWUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 17:20:50 -0500
Date: Thu, 3 Feb 2011 14:15:22 -0800
From: Greg KH <greg@kroah.com>
To: Yin Kangkai <kangkai.yin@linux.intel.com>
Cc: linux-serial@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        "Woodhouse, David" <david.woodhouse@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: change the divisor latch only when prescalar
 actually changed
Message-ID: <20110203221522.GA4019@kroah.com>
References: <20110125070154.GI3315@kai-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125070154.GI3315@kai-debian>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 03:01:54PM +0800, Yin Kangkai wrote:
> From: Yin Kangkai <kangkai.yin@intel.com>
> 
> In 8250.c original ns16550 autoconfig code, we change the divisor latch when
> we goto to high speed mode, we're assuming the previous speed is legacy. This
> some times is not true.

This doesn't apply to the linux-next tree, care to refresh it and resend
it?

thanks,

greg k-h
