Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab0D1W2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:28:20 -0400
Received: from kroah.org ([198.145.64.141]:34844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab0D1W2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:28:17 -0400
Date: Wed, 28 Apr 2010 15:28:10 -0700
From: Greg KH <greg@kroah.com>
To: Hank Janssen <hjanssen@microsoft.com>,
       Ky Srinivasan <ksrinivasan@novell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Haiyang Zhang <haiyangz@microsoft.com>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/1] hv: Added new hv_utils driver to hyper-v
Message-ID: <20100428222810.GA18247@kroah.com>
References: <8AFC7968D54FB448A30D8F38F259C5621AFEC6F3@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C5621AFEC6F3@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 10:11:02PM +0000, Hank Janssen wrote:
> 
> From: Hank Janssen <hjanssen@microsoft.com>
> 
> Addition of new driver for Hyper-V called hv_utils.
> This driver is intended to support things like KVP, Timesync, Heartbeat etc.

Does this duplicate functionality in KY's clocksource driver?  Or is it
a separate thing?

> This first release has support for graceful shutdown.
> e.g. Select shutdown from the Hyper-V main admin screen and the
> Linux VM will do a graceful shutdown.
> 
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

I did not sign off on this, I've never even seen this patch before, why
would you add my name?  That is not ok at all!

greg k-h
