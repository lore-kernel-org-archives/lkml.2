Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab0D0Nrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:47:42 -0400
Received: from mail2.shareable.org ([80.68.89.115]:48150 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab0D0Nrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:47:41 -0400
Date: Tue, 27 Apr 2010 14:47:37 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Kevin Cernekee <cernekee@gmail.com>, linux-mtd@lists.infradead.org,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       saeed.bishara@gmail.com, dedekind1@gmail.com
Subject: Re: [PATCHv2 1/2] MTD: cfi_cmdset_0002: Add reboot notifier for AMD flashes
Message-ID: <20100427134737.GB25405@shareable.org>
References: <1271221078.2532.5.camel@localhost.localdomain> <a00f98bfcda7db841108605ebab8d07363f4aa8b@localhost.localdomain> <20100415025321.GB14954@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415025321.GB14954@pengutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang wrote:
> On Wed, Apr 14, 2010 at 05:57:33PM -0700, Kevin Cernekee wrote:
> > Ensure that the flash device is in a quiescent state before rebooting.
> > The implementation is closely modeled after the cfe_cmdset_0001 reboot
> > notifier, commit 963a6fb0a0d336d0513083b7e4b5c3ff9d6d2061 .
> > 
> > Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> 
> Yes, if this is present for Intel, it should be present for AMD, IMHO.
> 
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>
> 
> Still, the correct solution is to wire the correct reset-line to the flashes.
> Above patch will not help if a watchdog kicks in. Been there :(

Isn't the patch intended to handle _software_ resets where the hard reset
line isn't toggled?

-- Jamie
