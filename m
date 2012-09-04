Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab2IDVsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:48:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60598 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760Ab2IDVsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:48:36 -0400
Message-ID: <5046772F.6060908@wwwdotorg.org>
Date: Tue, 04 Sep 2012 15:48:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: balbi@ti.com
CC: Venu Byravarasu <vbyravarasu@nvidia.com>, ccross@android.com,
        olof@lixom.net, linux@arm.linux.org.uk, stern@rowland.harvard.edu,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2] usb: move phy driver from mach-tegra to drivers/usb
References: <1346395526-18219-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1346395526-18219-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2012 12:45 AM, Venu Byravarasu wrote:
> As part of this patch:
> 	1. Moved existing tegra phy driver to drivers/USB directory.
> 	2. Added standard USB phy driver APIs to tegra phy driver.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>

Tested-by: Stephen Warren <swarren@nvidia.com>

Felipe, Would it be possible to apply this patch to a topic branch, so
that I can merge it into the Tegra tree? The reason is that I'd like to
remove Tegra's devices.[ch] in kernel 3.7, but to do that, I need to
move a tiny chunk of code out of that file somewhere else, and doing
that relies on adding a #include to usb_phy.h/tegra_usb_phy.h, which is
renamed in this patch.

Alternatively, if you don't think it'll cause any merge conflicts with
the USB PHY tree, I can just take this patch through the Tegra tree if
you want. Venu, do you plan any other patches within the next couple
weeks or so (i.e. before 3.6-rc6) that will depend on this patch? If so,
taking it only through the Tegra tree might not work so well.

Thanks.
