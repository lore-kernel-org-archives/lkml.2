Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab2CFRGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:06:05 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55910 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab2CFRGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:06:03 -0500
Message-ID: <4F56424A.3020305@wwwdotorg.org>
Date: Tue, 06 Mar 2012 09:58:50 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Dmitry Artamonow <mad_soft@inbox.ru>
CC: linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/2] arm/tegra: add timeout to PCIe PLL lock detection
 loop
References: <1331023544-6439-1-git-send-email-mad_soft@inbox.ru> <1331023544-6439-3-git-send-email-mad_soft@inbox.ru>
In-Reply-To: <1331023544-6439-3-git-send-email-mad_soft@inbox.ru>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 01:45 AM, Dmitry Artamonow wrote:
> Tegra PCIe driver waits for PLL to lock using busy loop.
> If PLL fails to lock for some reason, this leads to silent lockup
> while booting (as PCIe code is not modular).
> 
> Fix by adding timeout, so if PLL doesn't lock in a couple
> of seconds, just PCIe driver fails and machine continues to boot.
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>

That seems reasonable. So once the mdelay discussion is resolved,

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Any idea why the PLL doesn't lock sometimes?
