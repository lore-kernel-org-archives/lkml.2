Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab1BPO5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 09:57:39 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57885 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751071Ab1BPO5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 09:57:36 -0500
Date: Wed, 16 Feb 2011 09:57:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Len Brown <lenb@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC][PATCH 2/2] PM: Make system-wide PM and runtime PM handle
 subsystems consistently
In-Reply-To: <201102161324.49633.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1102160955210.2108-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011, Rafael J. Wysocki wrote:

> Unfortunately, it doesn't work on my Acer Ferrari One.  The problem is that
> hcd_pci_suspend() fails for the EHCI controller, apparently because the root
> hub is not suspended.  Do root hubs need both class suspend and bus type
> suspend to work at the same time?

No, only the bus type suspend method is needed.  Can you provide the
dmesg log using a kernel built with CONFIG_USB_DEBUG?

Alan Stern

