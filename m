Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103Ab2BNLZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:25:35 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2341 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab2BNLZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:25:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 14 Feb 2012 03:25:32 -0800
Message-ID: <4F3A4436.4090007@nvidia.com>
Date: Tue, 14 Feb 2012 16:53:34 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regulator enable/disable delay based on board design: How to
 handle?
References: <4F38D55A.5020208@nvidia.com> <20120213163711.GD3494@opensource.wolfsonmicro.com> <4F394F28.70709@nvidia.com> <20120214010946.GE11931@opensource.wolfsonmicro.com>
In-Reply-To: <20120214010946.GE11931@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 February 2012 06:39 AM, Mark Brown wrote:
> This is part of the reason why the driver_data field is present in the
> constraints - the driver can take that and use it as a pdata within
> pdata structure.  It's not terribly nice to do that but it's possible.
Ok, I was thinking that driver data is specific to machine file and 
driver will pass this information to the function regulator_init() at 
the time of call.
But I think it is fine to use this for driver specific data for my case.
Thanks lot for suggestion,
> A standard parameter might cause too much complexity as drivers try to
> implement it even if they don't really need to (for example, due to
> having soft control of this stuff already).

I was thinking that this will be taken care by core if board files 
override the value (non-zero). So if it is zero then just ignore this 
parameters otherwise take this value and ignore what driver is returning.
Hence option will be as per data sheet (what driver is returning) or as 
per board designs (if some more delay is require than specified in 
datasheet).

Thanks,
Laxman

