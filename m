Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab2KOVk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:40:28 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37379 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2KOVkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:40:20 -0500
Message-ID: <50A5613D.5080601@wwwdotorg.org>
Date: Thu, 15 Nov 2012 14:40:13 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Danny Huang <dahuang@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/3] ARM: tegra: add speedo identification for T20/T30
References: <1352965354-650-1-git-send-email-dahuang@nvidia.com>
In-Reply-To: <1352965354-650-1-git-send-email-dahuang@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 12:42 AM, Danny Huang wrote:
> This patch series adds speedo identification functionality for tegra
> T20 and T30. It reads speedo value from fuse and chooses CPU and core 
> process ID by checking speedo corner tables.

I think this all looks fine; I assume there will be some forthcoming
usage of the new variables.

I applied the series with some very minor changes to the printfs and
commit description to that "Tegra20" was consistently used instead of
"T20" or "Tegra2", and the same for Tegra30.
