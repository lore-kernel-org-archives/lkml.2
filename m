Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab2KMTNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:13:34 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39737 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab2KMTN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:13:29 -0500
Message-ID: <50A29BD7.4020209@wwwdotorg.org>
Date: Tue, 13 Nov 2012 12:13:27 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: tegra: Add OF_DEV_AUXDATA for sflash driver
 in board dt
References: <1352783021-25393-1-git-send-email-ldewangan@nvidia.com> <1352783021-25393-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1352783021-25393-3-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 10:03 PM, Laxman Dewangan wrote:
> Add OF_DEV_AUXDATA for sflash controller driver for Tegra20
> board dt files.
> Set the parent clock of sflash controller to PLLP and configure
> clock to 20MHz.

Thanks, applied to Tegra's for-3.8/soc branch.

