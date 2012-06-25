Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab2FYPqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:46:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46131 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab2FYPqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:46:37 -0400
Message-ID: <4FE887DA.2040308@wwwdotorg.org>
Date: Mon, 25 Jun 2012 09:46:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, ldewangan@nvidia.com
Subject: Re: [PATCH] dma: tegra: add clk_prepare/clk_unprepare
References: <1340605891-19076-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1340605891-19076-1-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 12:31 AM, Prashant Gaikwad wrote:
> Use clk_prepare/clk_unprepare as required by the generic clk framework.
> 
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
