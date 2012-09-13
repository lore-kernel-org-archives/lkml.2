Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab2IMPJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:09:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50486 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757842Ab2IMPJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:09:19 -0400
Message-ID: <5051F71B.6030604@wwwdotorg.org>
Date: Thu, 13 Sep 2012 09:09:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: tegra: fixing compilation error
References: <1347513385-14158-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1347513385-14158-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 11:16 PM, Venu Byravarasu wrote:
> As usb_phy.h got moved from mach to include/linux/usb
> and renamed as tegra_usb_phy.h, correcting it in the include
> path.

This should no longer be necessary assuming there's a new linux-next today.

(Note that I did point out this issue on our internal mailing list; are
you not subscribed to that?)
