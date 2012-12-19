Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab2LSRDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 12:03:03 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40049 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab2LSRC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 12:02:56 -0500
Message-ID: <50D1F33D.1050709@wwwdotorg.org>
Date: Wed, 19 Dec 2012 10:02:53 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: djbw@fb.com, vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        swarren@nvidia.com, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] dma: tegra: implement flags parameters for cyclic transfer
References: <1355924434-7930-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1355924434-7930-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 06:40 AM, Laxman Dewangan wrote:
> The flag parameter is added in the cyclic transfer request.
> Use the flag option of:
> - DMA_PREP_INTERRUPT for enabling interrupt.
> - DMA_CTRL_ACK for deciding whether ack is requred or not for
>   descriptor.

Do the relevant drivers that use Tegra's DMA engine already set flags
correctly, so that this change won't cause any regressions?

Why would you not want to enable interrupts; how does a client know when
to refill the buffer?

