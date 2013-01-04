Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab3ADQZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 11:25:36 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37127 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab3ADQZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 11:25:34 -0500
Message-ID: <50E7027A.1090102@wwwdotorg.org>
Date: Fri, 04 Jan 2013 09:25:30 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@linaro.org, swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] clk: tegra30: Convert clk out to composite clk
References: <1357278706-28149-1-git-send-email-pgaikwad@nvidia.com> <1357278706-28149-2-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1357278706-28149-2-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 10:51 PM, Prashant Gaikwad wrote:
> Convert clk out to composite clock type which removes
> the mux clock.
> 
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
> ---
> This patch is rebased on ccf-rework for Tegra patch series. It is just to show
> how clk-composite can be used, not to be merged. If patch 1 is accepted then
> I would like to merge this patch to ccf-rework series.

Just so I'm clear, is the intent that patch 1 of this series gets
reviewed/accepted, and then you'll repost an updated version of the
Tegra CCF rework series that relies on patch 1? If so, patch 1 would
need to be either taken through the Tegra tree, or put into a separate
branch in the clock tree, so the Tegra tree can merge it as a dependency
of the Tegra CCF rework branch.
