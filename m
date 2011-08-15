Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab1HOLN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 07:13:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53911 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab1HOLN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 07:13:26 -0400
Message-ID: <4E48FF29.1030208@ru.mvista.com>
Date: Mon, 15 Aug 2011 15:12:41 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 12/12] arm/tegra: Remove temporary gpio/pinmux registration
 workaround
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com> <1313189697-21287-13-git-send-email-swarren@nvidia.com>
In-Reply-To: <1313189697-21287-13-git-send-email-swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 13-08-2011 2:54, Stephen Warren wrote:

> This reverts commit "arm/tegra: Prevent duplicate gpio/pinmux pdev

    Would be good to also include the commit ID for gitweb.

> registration with dt"; board-dt.c no long calls harmony/
> seaboard_pinmux_init(), so the workaround is no longer needed.

> Signed-off-by: Stephen Warren<swarren@nvidia.com>

WBR, Sergei

