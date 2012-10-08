Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab2JHGgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:36:46 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16293 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2JHGgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:36:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 07 Oct 2012 23:36:44 -0700
Message-ID: <50726C9F.1030502@nvidia.com>
Date: Mon, 8 Oct 2012 11:33:11 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: Re: [PATCH 2/5] mfd: tps65090: add error prints when mem alloc failed
References: <1349623340-21807-1-git-send-email-ldewangan@nvidia.com>	 <1349623340-21807-3-git-send-email-ldewangan@nvidia.com> <1349626414.15802.2.camel@joe-AO722>
In-Reply-To: <1349626414.15802.2.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 October 2012 09:43 PM, Joe Perches wrote:
> On Sun, 2012-10-07 at 20:52 +0530, Laxman Dewangan wrote:
>> Add error prints when memory allocation failed for
>> tps65090 data. Also cleanups the melloc arguments.
> The new dev_err is unnecessary.
> A dump_stack is already done on alloc failures.
> The sizeof(* is ok.
>

I think this will also prints the device name for which it fails and so 
when we have multiple device, it will help to find out the failure case.

Thanks,
Laxman
