Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab2IKQem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 12:34:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47783 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab2IKQek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 12:34:40 -0400
Message-ID: <504F681E.4070402@wwwdotorg.org>
Date: Tue, 11 Sep 2012 10:34:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: balbi@ti.com
CC: Venu Byravarasu <vbyravarasu@nvidia.com>, linux-kernel@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] usb: move phy driver from mach-tegra to drivers/usb
References: <1346851223-29180-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1346851223-29180-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 07:20 AM, Venu Byravarasu wrote:
> As part of this patch:
> 	1. Moved existing tegra phy driver to drivers/USB directory.
> 	2. Added standard USB phy driver APIs to tegra phy driver.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>

Felipe,

I see this patch hasn't been applied yet. Can I ask that it be deferred
to 3.8 rather than being applied for 3.7. The reason is that in 3.7, I
want to add a new include of the header that this patch moves, and
without merging the Tegra and USB PHY trees together, the two patches
together would cause a build break. Now, it's a little late to merge the
branches, since I need to send my pull requests in about 3 days, so they
hit arm-soc by 3.6-rc6.

Thanks.
