Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab2BHPIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 10:08:04 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43629 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755318Ab2BHPHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 10:07:53 -0500
Date: Wed, 8 Feb 2012 10:07:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Alex Shi <alex.shi@intel.com>, Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <andiry.xu@amd.com>,
        <linux-kernel@vger.kernel.org>, Oliver Neukum <oneukum@suse.de>,
        Takashi Iwai <tiwai@suse.de>, <trenn@suse.de>,
        <linux-pci@vger.kernel.org>, Michal Marek <MMarek@suse.com>
Subject: Re: [PATCH] usb: enable pci MSI/MSIX in usb core
In-Reply-To: <20120207221317.GA6103@xanatos>
Message-ID: <Pine.LNX.4.44L0.1202081006470.1697-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Feb 2012, Sarah Sharp wrote:

> Alan, is the hc_driver structure (xhci_pci_hc_driver) shared across all
> xHCI PCI hosts in the system?

Maybe this isn't relevant to the discussion any more...  but yes, it 
is.

Alan Stern

