Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab2IMRTC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:19:02 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57967 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758650Ab2IMRS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:18:59 -0400
Message-ID: <5052157F.8040201@wwwdotorg.org>
Date: Thu, 13 Sep 2012 11:18:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: stern@rowland.harvard.edu, gregkh@linuxfoundation.org, balbi@ti.com,
        swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2] USB: PHY: Re-organize Tegra USB PHY driver
References: <1347519738-24162-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1347519738-24162-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 01:02 AM, Venu Byravarasu wrote:
> NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc.
> In order to support USB PHY drivers on these SoCs, existing
> PHY driver is split into SoC agnostic common USB PHY driver
> and Tegra20-specific USB phy driver. This will facilitate
> easy addition and deletion of phy drivers for Tegra SoCs.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>

Tested-by: Stephen Warren <swarren@wwwdotorg.org>
