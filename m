Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716Ab2JaRda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:33:30 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14077 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851Ab2JaRd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:33:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 31 Oct 2012 10:33:21 -0700
Message-ID: <5091607D.8010907@nvidia.com>
Date: Wed, 31 Oct 2012 23:01:41 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 0/4] ARM: tegra: Enable SLINK controller driver
References: <1351674176-20603-1-git-send-email-ldewangan@nvidia.com> <50915203.8030505@wwwdotorg.org>
In-Reply-To: <50915203.8030505@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2012 09:59 PM, Stephen Warren wrote:
> On 10/31/2012 03:02 AM, Laxman Dewangan wrote:
>> This series modify the dts file to add the slink addresses,
>> make AUXDATA in board dt files, enable slink4 for tegra30-cardhu and
>> enable slink controller defconfig.
> I don't appear to have received patch 1/4 this time around. I'll assume
> it's identical to V3, since I don't think anything needed to change there...

Yes, it is identical to V3, no change on the 1/4.
Only change in 3/4 and 4/4. I realize later that you already applied the 
2/4 yesterday.
