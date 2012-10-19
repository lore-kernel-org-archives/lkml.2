Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab2JSOqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:46:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52029 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751917Ab2JSOqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:46:51 -0400
Date: Fri, 19 Oct 2012 10:46:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Venu Byravarasu <vbyravarasu@nvidia.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
In-Reply-To: <1350643085-27294-1-git-send-email-vbyravarasu@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1210191046050.1498-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012, Venu Byravarasu wrote:

> NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc.
> In order to support USB PHY drivers on these SoCs, existing
> PHY driver is split into SoC agnostic common USB PHY driver
> and Tegra20-specific USB phy driver. This will facilitate
> easy addition and deletion of phy drivers for Tegra SoCs.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
> delta from v3 resend:
> For unknown reasons, email-id in signed-off-by got corrupted.
> Hence re-sending the patch, after fixing it.
> 
> delta from v3:
> Rebased the v3 changes on top of xceiv branch.
> 
> delta from v2:
> Added an if condition to check for device_node to be not NULL,
> before dereferencing it.

For the changes to drivers/usb/host/ehci-tegra.c:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

