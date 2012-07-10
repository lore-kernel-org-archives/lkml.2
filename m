Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2GJPMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:12:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58719 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753600Ab2GJPMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:12:36 -0400
Date: Tue, 10 Jul 2012 11:12:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Greg KH <greg@kroah.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russ Dill <Russ.Dill@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: manual merge of the usb tree with the mfd tree
In-Reply-To: <20120710155116.3dd45f8c86d8dc540e2091a8@canb.auug.org.au>
Message-ID: <Pine.LNX.4.44L0.1207101111040.1308-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012, Stephen Rothwell wrote:

> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/host/ehci-omap.c between commit 2761a6394516 ("mfd: USB: Fix
> the omap-usb EHCI ULPI PHY reset fix issues") from the mfd tree and
> commit 1a49e2ac9651 ("EHCI: centralize controller initialization") from
> the usb tree.
> 
> I am not sure how to fix this up, I have just effectively reverted the
> effect of the former commit on this file.

That agrees with Greg's decision.  Russ's patch (commit 2761a6) should 
be rebased on top of 1a49e2.

Thanks,

Alan Stern

