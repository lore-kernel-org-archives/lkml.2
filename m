Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab2KSQ0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 11:26:15 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33870 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab2KSQ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:26:14 -0500
Message-ID: <50AA5DA2.3010200@wwwdotorg.org>
Date: Mon, 19 Nov 2012 09:26:10 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sivaram Nair <sivaramn@nvidia.com>
CC: a.zummo@towertech.it, linux-tegra@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] rtc: tps65910: renaming irq to match device
References: <1353313413-17382-1-git-send-email-sivaramn@nvidia.com>
In-Reply-To: <1353313413-17382-1-git-send-email-sivaramn@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 01:23 AM, Sivaram Nair wrote:
> This is a cosmetic change to rename the irq name to match the device
> name.

I believe you need to repost this to Andrew Morton since he's been
picking up RTC patches.

You don't need to post the patch to linux-tegra@ since it doesn't have
anything to do with Tegra really, even though Tegra happens to use the
driver.
