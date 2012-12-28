Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab2L1ABz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 19:01:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59637 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab2L1ABy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 19:01:54 -0500
Message-ID: <50DCE160.2040707@zytor.com>
Date: Thu, 27 Dec 2012 16:01:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, realmode: set real_mode permissions early
References: <20121227182232.GA10054@x1.alien8.de> <CAE9FiQXpAB_AFtHF_NN7yr2iP2OOLgMir8MNvYUUc15k83_3zg@mail.gmail.com>
In-Reply-To: <CAE9FiQXpAB_AFtHF_NN7yr2iP2OOLgMir8MNvYUUc15k83_3zg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2012 03:56 PM, Yinghai Lu wrote:
>>
>> I'm looking at this patch in the -v8 branch: you need to update the
>> comment above that function to say that trampoline code needs to be
>> marked X now earlier.
>
> Not sure if we really need to add such comment in the code.
>
> Peter, what is your idea about this?
>

It would be good to note why the early_initcall is the right phase.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

