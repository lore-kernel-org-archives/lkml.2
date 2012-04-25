Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab2DYHOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 03:14:43 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18226 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab2DYHOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 03:14:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 25 Apr 2012 00:14:41 -0700
Message-ID: <4F97A40E.1090208@nvidia.com>
Date: Wed, 25 Apr 2012 12:43:18 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Gerard Snitselaar <dev@snitselaar.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd/tps65910: fix section mismatch in linux-next
References: <1335280435-2457-1-git-send-email-dev@snitselaar.org>
In-Reply-To: <1335280435-2457-1-git-send-email-dev@snitselaar.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2012 08:43 PM, Gerard Snitselaar wrote:
> tps65910_i2c_probe() calls tps65910_sleepinit() which is annnotated __init.
>
> Signed-off-by: Gerard Snitselaar<dev@snitselaar.org>
> ---
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
