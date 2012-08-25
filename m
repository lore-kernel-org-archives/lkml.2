Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209Ab2HYEV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 00:21:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42082 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab2HYEVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 00:21:23 -0400
Message-ID: <503852BE.1010908@zytor.com>
Date: Fri, 24 Aug 2012 21:21:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/5] x86: Only direct map addresses that are marked as
 E820_RAM
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com> <1345852516-3125-4-git-send-email-jacob.shin@amd.com> <50381C9D.5070007@zytor.com> <20120825004859.GB10812@jshin-Toonie> <5038269E.80707@zytor.com> <20120825042020.GC26127@jshin-Toonie>
In-Reply-To: <20120825042020.GC26127@jshin-Toonie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 09:20 PM, Jacob Shin wrote:
>>
>> What is the benefit?
>
> So that in the case where we have E820_RAM right above 1MB, we don't
> call init_memory_mapping twice, first on 0 ~ 1MB and then 1MB ~ something
>
> we only call it once. 0 ~ something.
>

So what is the benefit?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

