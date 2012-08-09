Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab2HIRkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:40:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52759 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab2HIRkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:40:14 -0400
Message-ID: <5023F3B4.8010402@wwwdotorg.org>
Date: Thu, 09 Aug 2012 11:30:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: olof@lixom.net, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 0/3] ARM: dt: tegra: cardhu: add entry for regulators
References: <1344510039-17754-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1344510039-17754-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 05:00 AM, Laxman Dewangan wrote:
> This patch series add the PMIC and fixed regulators for 
> cardhu board. There is multiple versions of cardhu baord named
> as A01, A02, A03..and so on. Cardhu A01 and A03 are not supported.
> Cardhu A02 and A04 have different sets of GPIO for regualtors.
> The cardhu A04 is compatible for A05, A06 and A07 in GPIOs.
> This patch series split the cardhu dts file to cardhu-a02 and 
> carchu-a04 and then add entry for different fixed regualtors.

Thanks, applied the series to Tegra's for-3.7/dt branch.

