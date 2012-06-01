Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579Ab2FAMWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 08:22:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56246 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759526Ab2FAMWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 08:22:44 -0400
Message-ID: <4FC8B3F5.5@mvista.com>
Date: Fri, 01 Jun 2012 16:22:13 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: swarren@nvidia.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, olof@lixom.net,
        linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>
Subject: Re: [PATCH 1/9] ARM: tegra: add clk_prepare/clk_unprepare
References: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com> <1338541968-7961-2-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1338541968-7961-2-git-send-email-pgaikwad@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01-06-2012 13:12, Prashant Gaikwad wrote:

> Use clk_prepare/clk_unprepare as required by the generic clk framework.

> This patch should go through Tegra tree since other patches to port Tegra
> to generic clock framework are dependent on it. Posting here to get ack from
> the maintainers.

    This paragraph should have followed the --- tear line; likewise in all the 
other patches. It's not fit for the patch description.

> Tested on Ventana and Cardhu.

> Signed-off-by: Prashant Gaikwad<pgaikwad@nvidia.com>

WBR, Sergei
