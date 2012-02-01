Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab2BANPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 08:15:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab2BANPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 08:15:47 -0500
Date: Wed, 1 Feb 2012 14:15:45 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-input@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pcmcia@lists.infradead.org, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] Dynamic ID addition doesn't need get_driver()
In-Reply-To: <Pine.LNX.4.44L0.1201241310400.1200-100000@iolanthe.rowland.org>
Message-ID: <alpine.LNX.2.00.1202011415250.18918@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1201241310400.1200-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012, Alan Stern wrote:

> As part of the removal of get_driver()/put_driver(), this patch
> (as1511) changes all the places that add dynamic IDs for drivers.
> Since these additions are done by writing to the drivers' sysfs
> attribute files, and the attributes are removed when the drivers are
> unregistered, there is no reason to take an extra reference to the
> drivers.
> 
> The one exception is the pci-stub driver, which calls pci_add_dynid()
> as part of its registration.  But again, there's no reason to take an
> extra reference here, because the driver can't be unloaded while it is
> being registered.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> CC: Jiri Kosina <jkosina@suse.cz>
> CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> CC: Dominik Brodowski <linux@dominikbrodowski.net>

Acked-by: Jiri Kosina <jkosina@suse.cz>

for the drivers/hid part. Thanks,

-- 
Jiri Kosina
SUSE Labs
