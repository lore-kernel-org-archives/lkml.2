Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3ABTHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 14:07:12 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:38753 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3ABTHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 14:07:09 -0500
Message-ID: <50E48559.9060007@wwwdotorg.org>
Date: Wed, 02 Jan 2013 12:07:05 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra30: tegra30 gpio is not compatible with tegra20
 gpio
References: <1355929032-26549-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1355929032-26549-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 07:57 AM, Laxman Dewangan wrote:
> tegra30 gpio controller is not compatible with the tegra20 due to
> their bank stride i.e. Tegra20 bank stride is 0x80 where Tegra30
> bank stride is 0x100.

Applied to Tegra's for-3.9/dt branch.

