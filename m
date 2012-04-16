Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2DPOPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:15:31 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14970 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab2DPOP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:15:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 16 Apr 2012 07:15:27 -0700
Message-ID: <4F8C268F.9080608@nvidia.com>
Date: Mon, 16 Apr 2012 19:32:55 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH] mfd: fix modular builds of rc5t583 regulator support
References: <1334549301-32114-1-git-send-email-paul.gortmaker@windriver.com> <4F8BC20A.2090105@nvidia.com> <4F8C28C5.9070308@windriver.com>
In-Reply-To: <4F8C28C5.9070308@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2012 07:42 PM, Paul Gortmaker wrote:
> On 12-04-16 02:54 AM, Laxman Dewangan wrote:
>> On Monday 16 April 2012 09:38 AM, Paul Gortmaker wrote:
>>
> As I said in the commit log, it doesn't seem to make sense to export
> them when they are trivial enough to be static inline, since it
> avoids having them pollute the /proc/kallsyms namespace.
>
> It is almost like having basic inb/outb as functions vs inline; it
> just doesn't make sense to me.
>
> However, if you are determined to rewrite the patch in another way,
> please add the customary reported-by line.
>

I am fine on either way i.e. inline or exporting symbols only.

