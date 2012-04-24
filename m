Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2DXGYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 02:24:51 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17108 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2DXGYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 02:24:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 23 Apr 2012 23:24:49 -0700
Message-ID: <4F9646E7.4000103@nvidia.com>
Date: Tue, 24 Apr 2012 11:53:35 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Gerard Snitselaar <dev@snitselaar.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mfd/tps65910: section mismatch for tps65910_sleepinit()
References: <20120424015916.GC2321@cantor.Home>
In-Reply-To: <20120424015916.GC2321@cantor.Home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2012 07:29 AM, Gerard Snitselaar wrote:
> While looking into another problem I noticed a section mismatch with
> tps65910_i2c_probe() calling tps65910_sleepinit() which is annotated
> __init. Should tps65910_i2c_probe() be annotated __init as well?
>
Yes, that should be __init. Let me know if you are sending patch or I 
need to do.

Thanks,
Laxman
