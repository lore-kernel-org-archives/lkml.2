Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab2BUFkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 00:40:40 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17192 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2BUFkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 00:40:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 20 Feb 2012 21:40:39 -0800
Message-ID: <4F432DC4.1060508@nvidia.com>
Date: Tue, 21 Feb 2012 11:08:12 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] mfd: tps65910: Initialize irq platform data properly
References: <1326898156-11293-1-git-send-email-ldewangan@nvidia.com> <20120220164506.GZ5387@sortiz-mobl>
In-Reply-To: <20120220164506.GZ5387@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Samuel for taking care.

On Monday 20 February 2012 10:15 PM, Samuel Ortiz wrote:
> Hi Laxman,
>
> On Wed, Jan 18, 2012 at 08:19:16PM +0530, Laxman Dewangan wrote:
>> irq_base of the tps65910 irq platform data should be
>> initialized with the board provided irq_base data.
> Thanks, patch applied to both my for-next and for-linus branches.
>
> Cheers,
> Samuel.
>

