Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab2KPFdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 00:33:12 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8085 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab2KPFdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 00:33:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 15 Nov 2012 21:33:11 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] Device tree updates for host1x support
Date: Fri, 16 Nov 2012 14:33:09 +0900
Message-ID: <14124199.Y0kYNzoKpq@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.3 (Linux/3.6.6-1-ARCH; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
References: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 November 2012 05:07:53 Thierry Reding wrote:
> This second version of this patch series splits the patches up into more
> logical chunks as requested by Stephen. Instead of renaming the matching
> parameters in the clock driver, this version renames the AUXDATA entries
> to match what the clock driver expects. Furthermore the host1x clock is
> initialized to 150 MHz instead of the unsupported 144 MHz.

Tested-and-acked-by: Alexandre Courbot <acourbot@nvidia.com>

