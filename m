Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2LUUzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 15:55:03 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55418 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab2LUUy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 15:54:58 -0500
Message-ID: <50D4CC9F.6080000@wwwdotorg.org>
Date: Fri, 21 Dec 2012 13:54:55 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, sshtylyov@mvista.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3] usb: phy: use kzalloc to allocate struct tegra_usb_phy
References: <1356071656-10052-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1356071656-10052-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 11:34 PM, Venu Byravarasu wrote:
> Use kzalloc instead of kmalloc to allocate struct tegra_usb_phy.
> This ensures that all function pointers in member u_phy are
> initialized to NULL.

Seems fine to me. For the record, I'd like to take this through the
Tegra tree with all the other Tegra-related USB patches in order to
manage any dependencies, with the USB maintainers' Acks. Thanks.
