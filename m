Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab1EKVOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:14:49 -0400
Received: from kroah.org ([198.145.64.141]:59130 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab1EKVOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:14:46 -0400
Date: Wed, 11 May 2011 14:07:45 -0700
From: Greg KH <greg@kroah.com>
To: matt mooney <mfmooney@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 03/12] staging: usbip: fix header includes
Message-ID: <20110511210745.GA4875@kroah.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
 <56b004a084644ec7e9f632d6633aa34177a59818.1305103212.git.mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56b004a084644ec7e9f632d6633aa34177a59818.1305103212.git.mfm@muteddisk.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 01:54:15AM -0700, matt mooney wrote:
> Modify header directives to include what is needed by each file and
> not already included in its own header.

This patch didn't apply properly:
	patching file drivers/staging/usbip/stub.h
	patching file drivers/staging/usbip/stub_dev.c
	patching file drivers/staging/usbip/stub_main.c
	patching file drivers/staging/usbip/stub_rx.c
	patching file drivers/staging/usbip/stub_tx.c
	patching file drivers/staging/usbip/usbip_common.c
	patching file drivers/staging/usbip/usbip_common.h
	patching file drivers/staging/usbip/usbip_event.c
	patching file drivers/staging/usbip/vhci.h
	patching file drivers/staging/usbip/vhci_hcd.c
	patching file drivers/staging/usbip/vhci_rx.c
	patching file drivers/staging/usbip/vhci_sysfs.c
	Hunk #1 FAILED at 17.
	1 out of 1 hunk FAILED -- saving rejects to file drivers/staging/usbip/vhci_sysfs.c.rej
	patching file drivers/staging/usbip/vhci_tx.c

What tree did you make it against?

thanks,

greg k-h
