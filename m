Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab2KZVAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:00:32 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41258 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab2KZVAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:00:30 -0500
Message-ID: <50B3D86C.40104@wwwdotorg.org>
Date: Mon, 26 Nov 2012 14:00:28 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sivaram Nair <sivaramn@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] arm: tegra: fix comment in dsib clk set_parent
References: <1353498147-14574-1-git-send-email-sivaramn@nvidia.com>
In-Reply-To: <1353498147-14574-1-git-send-email-sivaramn@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 04:42 AM, Sivaram Nair wrote:
> Since the clk framework has already taken necessary locks before calling
> into the arch clk ops code, no further locks are needed while setting
> the parent of dsib clk. This patch removes a comment that indicated
> otherwise, and yet did not take any locks.

Thanks, applied.


