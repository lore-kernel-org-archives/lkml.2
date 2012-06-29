Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab2F2RYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 13:24:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38509 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab2F2RYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 13:24:10 -0400
Message-ID: <4FEDE4B6.4010405@wwwdotorg.org>
Date: Fri, 29 Jun 2012 11:24:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux@arm.linux.org.uk, ccross@android.com, olof@lixom.net
Subject: Re: [PATCH 0/6] Port Tegra to generic clk framework
References: <1340879846-12900-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1340879846-12900-1-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 04:37 AM, Prashant Gaikwad wrote:
> This patch set ports Tegra clock code to generic clock framework.
> 
> Depends on
> [PATCH v3 0/9] Add clk_prepare/clk_unprepare series
> [PATCH] ARM: tegra: Remove second instance of uart clk
> [PATCH] dma: tegra: add clk_prepare/clk_unprepare
> [PATCH] ARM: tegra: dma: rename driver name for clock to "tegra-apbdma"

Prashant, this doesn't apply either to my local development tree
(roughly what's in next-20120629), nor Tegra's for-3.6/common-clk
branch. Can you please regenerate the series on top of
for-3.6/common-clk. Thanks.
