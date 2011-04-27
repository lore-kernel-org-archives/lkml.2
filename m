Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab1D0PRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:17:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:45177 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307Ab1D0PRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:17:49 -0400
Date: Wed, 27 Apr 2011 08:05:07 -0700
From: Greg KH <gregkh@suse.de>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se
Subject: Re: [PATCH 1/8] staging/mei: PCI device and char driver support.
Message-ID: <20110427150507.GC24596@suse.de>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
 <1303900057-21694-2-git-send-email-oren.jer.weil@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303900057-21694-2-git-send-email-oren.jer.weil@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 01:27:30PM +0300, Oren Weil wrote:
> contains module entries and PCI driver and char device
> definitions (using file_operations, pci_driver structs).

That's a very lame description.  Please be more verbous, like you did on
the 0/8 patch, that explains what this code is and how it is accessed.

Same goes for the other patches in this series, you need to explain
things more.

thanks,

greg k-h
