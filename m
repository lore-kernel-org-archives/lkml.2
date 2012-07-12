Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161214Ab2GLObV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:31:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34495 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161188Ab2GLObS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:31:18 -0400
Date: Thu, 12 Jul 2012 10:31:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Laxman Dewangan <ldewangan@nvidia.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <swarren@nvidia.com>, <vbyravarasu@nvidia.com>
Subject: Re: [PATCH] usb: host: tegra: pass correct pointer in ehci_setup()
In-Reply-To: <1342082208-14184-1-git-send-email-ldewangan@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1207121029480.1413-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012, Laxman Dewangan wrote:

> The ehci_setup() require the pointer of usb_hcd.
> Passing the correct pointer in place of ehci_hcd
> pointer.
> 
> This is side effetct of change:
> commit 1a49e2ac9651df7349867a5cf44e2c83de1046af
> Author: Alan Stern <stern@rowland.harvard.edu>
> 
>     EHCI: centralize controller initialization
> 
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Argh!  You're perfectly right, of course.  I thought I had checked all 
those calls carefully.

Anyway, two other calls need to be fixed as well.  I'll resubmit your 
patch, with the other two fixes included.  Okay?

Alan Stern

