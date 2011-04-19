Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1DSWHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 18:07:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab1DSWHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 18:07:50 -0400
Date: Tue, 19 Apr 2011 15:07:43 -0700
From: Chris Wright <chrisw@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: pugs@ieee.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        qemu-devel@nongnu.org, chrisw@redhat.com, aafabbri@cisco.com,
        dwang2@cisco.com, benve@cisco.com
Subject: Re: [PATCH] vfio: Add an ioctl to reset the device
Message-ID: <20110419220743.GO12133@x200.localdomain>
References: <20110419203234.4254.94914.stgit@s20.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419203234.4254.94914.stgit@s20.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Williamson (alex.williamson@redhat.com) wrote:
> When using VFIO to assign a device to a guest, we want to make sure
> the device is quiesced on VM reset to stop all DMA within the guest
> mapped memory.  Add an ioctl which just calls pci_reset_function()
> and returns whether it succeeds.

Shouldn't there be a reset when binding/unbinding vfio to/from a pci
device?
