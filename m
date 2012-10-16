Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab2JPRaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:30:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37513 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab2JPRaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:30:10 -0400
Message-ID: <507D99A0.1030701@wwwdotorg.org>
Date: Tue, 16 Oct 2012 11:30:08 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Sivaram Nair <sivaramn@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ARM: tegra: bring back tegra_timer clock
References: <1350382116-18024-1-git-send-email-sivaramn@nvidia.com>
In-Reply-To: <1350382116-18024-1-git-send-email-sivaramn@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 04:08 AM, Sivaram Nair wrote:
> This patchset fixes a bug introduced by commit
> 20f4665831cec65d6e5d33587bba28ffa536b91d by bringing back the
> tegra_timer clock.  The above commit caused tegra_init_timer() failing
> to get the clk reference.
> 
> The first patch renames the existing tegra_timer object to
> tegra_sys_timer and the second patch adds previously-removed tegra_timer
> clock object.

Thanks. The series applied to Tegra's for-3.7/fixes-for-rc2 branch.
Sorry for the regression.
