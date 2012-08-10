Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab2HJQsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 12:48:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36217 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab2HJQsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 12:48:54 -0400
Message-ID: <50253B72.5030209@wwwdotorg.org>
Date: Fri, 10 Aug 2012 10:48:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: olof@lixom.net, linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: use IO_ADDRESS for getting virtual address
References: <1344603782-2541-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1344603782-2541-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2012 07:03 AM, Laxman Dewangan wrote:
> Use macro IO_ADDRESS for getting virtual address of
> corresponding physical address to make the consistency
> with rest of Tegra code-base.
> This macro calls the IO_TO_VIRT() which is defined in
> arch/arm/mach-tegra/include/mach/iomap.h

Thanks, applied to Tegra's for-3.7/fixes.
