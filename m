Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab2JSJHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:07:20 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18258 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab2JSJHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:07:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 19 Oct 2012 02:07:14 -0700
Message-ID: <50811817.1070806@nvidia.com>
Date: Fri, 19 Oct 2012 14:36:31 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] ARM: tegra: Add slink controller base address
References: <1350557795-31487-1-git-send-email-ldewangan@nvidia.com> <1350557795-31487-2-git-send-email-ldewangan@nvidia.com> <50808526.1080504@wwwdotorg.org>
In-Reply-To: <50808526.1080504@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2012 04:09 AM, Stephen Warren wrote:
> On 10/18/2012 04:56 AM, Laxman Dewangan wrote:
>> Add base address of all slink controller of Tegra20
>> and tegra30.
> Lets not add anything to iomap.h; we're trying to remove it. Instead,
> just put the raw address in the AUXDATA; I assume that's the only place
> these defines end up being used...
OK, I will drop this change and add the base address definition in the 
AUXDATA file only.
