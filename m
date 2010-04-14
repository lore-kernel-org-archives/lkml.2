Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab0DNU3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 16:29:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56577 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755619Ab0DNU3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 16:29:23 -0400
Date: Wed, 14 Apr 2010 16:29:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Chris Wright <chrisw@sous-sol.org>
cc: Daniel Mack <daniel@caiaq.de>, David Woodhouse <dwmw2@infradead.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <iommu@lists.linux-foundation.org>, Andi Kleen <andi@firstfloor.org>,
       Pedro Ribeiro <pedrib@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <20100414183826.GA25962@sequoia.sous-sol.org>
Message-ID: <Pine.LNX.4.44L0.1004141622410.1716-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010, Chris Wright wrote:

> So dma_map_single is the case that's failing, but you think the mask is
> correct?  What about the direction?

The mask and direction are unquestionably correct.  The mask is set up 
by pci_setup_device() and not changed thereafter.  Furthermore, the 
audio works okay until another device (a DVB tuner) is plugged in.  

Alan Stern

