Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab2GSXxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 19:53:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38994 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2GSXxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 19:53:37 -0400
Date: Thu, 19 Jul 2012 16:53:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        abbotti@mev.co.uk
Subject: Re: [PATCH 00/90] staging: comedi: cleanup the pci_dev usage
Message-ID: <20120719235321.GA13482@kroah.com>
References: <201207181823.21230.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207181823.21230.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 06:23:20PM -0700, H Hartley Sweeten wrote:
> All the comedi pci drivers currently store a pointer to the pci_dev
> in their private data. We can use the 'struct device *hw_dev' variable
> in the comedi_device struct instead and introduce a wrapper for
> to_pci_dev() to allow the drivers to easily get the pci_dev.
> 
> This patchset does just that. It also removes the private data from
> the drivers that no longer needed it.
> 
> Some of the drivers required a bit of cleanup to their "find pci device"
> code or the private data in order to make the conversion cleaner.
> 
> There are still a couple drivers, specifically the ni and addi ones,
> that need additional work before they can be converted cleanly.

I've applied all of these (with the updated 01/90 patch).  Can you
please send follow-on patches to resolve the issues that Ian pointed
out?

thanks,

greg k-h
