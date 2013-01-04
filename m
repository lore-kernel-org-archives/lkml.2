Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3ADTyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 14:54:36 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55873 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab3ADTye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:54:34 -0500
Message-ID: <50E73377.5070903@wwwdotorg.org>
Date: Fri, 04 Jan 2013 12:54:31 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: DT: tegra: add DT entry for KBC controller
References: <1357297442-28952-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1357297442-28952-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2013 04:04 AM, Laxman Dewangan wrote:
> NVIDIA's Tegra SoCs have the matrix keyboard controller which
> supports 16x8 type of matrix. The number of rows and columns
> are configurable.
> 
> Add DT entry for KBC controller.

These two look OK. Ping me once the related KBC driver changes are
checked in and I'll apply them.

