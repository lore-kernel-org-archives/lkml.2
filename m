Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab2CFRBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:01:04 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52613 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab2CFRBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:01:02 -0500
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2012 12:01:02 EST
Message-ID: <4F564170.7000209@wwwdotorg.org>
Date: Tue, 06 Mar 2012 09:55:12 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Dmitry Artamonow <mad_soft@inbox.ru>
CC: linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 1/2] arm/tegra: fix harmony pinmux for PCIe
References: <1331023544-6439-1-git-send-email-mad_soft@inbox.ru> <1331023544-6439-2-git-send-email-mad_soft@inbox.ru>
In-Reply-To: <1331023544-6439-2-git-send-email-mad_soft@inbox.ru>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 01:45 AM, Dmitry Artamonow wrote:
> Commit 6e96aca397 (arm/tegra: Harmony PCIe: Don't touch pinmux)
> removed runtime tri-state toggling for PCIe related pinmux groups,
> but it seems that the fact that all of them are tri-state by default
> has been overlooked. Change defaults for these groups to TEGRA_TRI_NORMAL.
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>

Crap, why didn't I check that? Anyway,

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
