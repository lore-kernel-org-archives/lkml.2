Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab0FWW2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 18:28:01 -0400
Received: from kroah.org ([198.145.64.141]:37753 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886Ab0FWW1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 18:27:37 -0400
Date: Wed, 23 Jun 2010 15:23:20 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: ss@aao.gov.au, gregkh@suse.de, devel@driverdev.osuosl.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Staging: dt3155: Cleanup memory mapped i/o access
Message-ID: <20100623222317.GA14659@kroah.com>
References: <201006221638.50754.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006221638.50754.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 04:38:50PM -0700, H Hartley Sweeten wrote:
> The macros ReadMReg and WriteMReg are really just private versions of
> the kernel's readl and writel functions.  Use the kernel's functions
> instead.  And since ioremap returns a (void __iomem *) not a (u8 *),
> change all the uses of dt3155_lbase to reflect this.

<snip>

Whatever you did to fix the email client issue up, it worked, thanks.

greg k-h
