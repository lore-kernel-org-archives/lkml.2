Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105Ab2K0DXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 22:23:09 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1979 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933066Ab2K0DXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 22:23:08 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 26 Nov 2012 19:22:54 -0800
Message-ID: <50B43205.8020604@nvidia.com>
Date: Tue, 27 Nov 2012 11:22:45 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ARM: dt: tegra: cardhu: Add drm components
References: <1353396472-24167-1-git-send-email-markz@nvidia.com> <50B3F886.3090701@wwwdotorg.org>
In-Reply-To: <50B3F886.3090701@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 07:17 AM, Stephen Warren wrote:
> On 11/20/2012 12:27 AM, Mark Zhang wrote:
>> This patch adds the rgb node which is needed by
>> tegra drm driver.
> 
> This doesn't seem to include all the GPIOs/regulators/... required to
> enable the panel and backlight.
> 

Yep. Actually I don't know much about panel & backlight stuffs and I
don't submit these patches.

For panel supporting, seems right now the "Generic Panel Framework" has
been changed to version 2 and be renamed as "Common Display Framework";
For backlight, Alex's power sequence patch is on the way.

So my patch just adds the rgb node in the dts.

Mark
