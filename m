Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab2IURqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:46:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57551 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab2IURqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:46:03 -0400
Message-ID: <505CA7D8.2010506@wwwdotorg.org>
Date: Fri, 21 Sep 2012 11:46:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3] USB: PHY: Re-organize Tegra USB PHY driver
References: <1348230054-7402-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1348230054-7402-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 06:20 AM, Venu Byravarasu wrote:
> NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc.
> In order to support USB PHY drivers on these SoCs, existing
> PHY driver is split into SoC agnostic common USB PHY driver
> and Tegra20-specific USB phy driver. This will facilitate
> easy addition and deletion of phy drivers for Tegra SoCs.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>

Tested-by: Stephen Warren <swarren@nvidia.com>

> ---
> delta from v2:
> 
> Added an if condition to check for device_node to be not NULL,
> before dereferencing it.

I suppose that doesn't hurt, but it's not strictly needed; this code
will only ever run on systems that boot using device tree now.

