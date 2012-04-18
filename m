Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab2DRQwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 12:52:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37793 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab2DRQwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 12:52:38 -0400
Message-ID: <4F8EF151.8050808@wwwdotorg.org>
Date: Wed, 18 Apr 2012 10:52:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Pavan Kunapuli <pkunapuli@nvidia.com>
CC: cjb@laptop.org, swarren@nvidia.com, paul.gortmaker@windriver.com,
        olof@lixom.net, rmk+kernel@arm.linux.org.uk, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1] mmc: tegra: support SDHCI SPEC 300
References: <1334755082-26818-1-git-send-email-pkunapuli@nvidia.com>
In-Reply-To: <1334755082-26818-1-git-send-email-pkunapuli@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 07:18 AM, Pavan Kunapuli wrote:
> Tegra3 SDHOST controller doesn't advertise
> v3.00 support by default. This support has to
> be enabled by configuring a vendor register in
> the tegra3 sd host address space.
> 
> Signed-off-by: Pavan Kunapuli <pkunapuli@nvidia.com>

FWIW,

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
