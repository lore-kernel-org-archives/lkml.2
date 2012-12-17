Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab2LQWGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:06:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56487 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750889Ab2LQWGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:06:13 -0500
Date: Mon, 17 Dec 2012 17:06:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@linuxfoundation.org>
cc: Stephen Warren <swarren@wwwdotorg.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>, Felipe Balbi <balbi@ti.com>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <sjg@chromium.org>,
        <olof@lixom.net>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm: tegra: Add new DT property to USB node.
In-Reply-To: <20121217211818.GA20835@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1212171704470.1409-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012, Greg KH wrote:

> You can't pick anything up for 3.9 until after 3.8-rc1 is out, according
> to the rules of linux-next

Well, you can accept a submission and store it in a private tree until 
then.  You just can't put it in any tree that feeds into linux-next.

Alan Stern

