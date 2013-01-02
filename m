Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3ABSVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 13:21:17 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46991 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3ABSVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 13:21:16 -0500
Message-ID: <50E47A97.2000401@wwwdotorg.org>
Date: Wed, 02 Jan 2013 11:21:11 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Josh Cartwright <josh.cartwright@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V4 3/3] ARM: tegra: move timer.c to drivers/clocksource/
References: <1353453142-4973-1-git-send-email-swarren@wwwdotorg.org> <1353453142-4973-3-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1353453142-4973-3-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 04:12 PM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Move arch/arm/mach-tegra/timer.c to drivers/clocksource/tegra20_timer.c
> so that the code is co-located with other clocksource drivers, and to
> reduce the size of the mach-tegra directory.

I have applied this to Tegra's for-3.9/cleanup branch.
