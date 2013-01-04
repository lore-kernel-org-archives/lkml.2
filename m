Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3ADRQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 12:16:04 -0500
Received: from linode.aoot.com ([69.164.194.13]:41202 "EHLO linode.aoot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab3ADRQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 12:16:01 -0500
Message-ID: <50E70E48.3010900@opengridcomputing.com>
Date: Fri, 04 Jan 2013 11:15:52 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH -v2 09/26] infiniband: rename random32() to prandom_u32()
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com> <1357215562-6288-10-git-send-email-akinobu.mita@gmail.com> <50E5B183.4030706@opengridcomputing.com> <CAC5umygnMMC2sH2c88P_gEWTgwM=CBCUcqBbo+NX=fOZ2rEGxw@mail.gmail.com>
In-Reply-To: <CAC5umygnMMC2sH2c88P_gEWTgwM=CBCUcqBbo+NX=fOZ2rEGxw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm asking: why are you bothering with renaming the functions?  This 
seems like a needless change, _unless_ there are really 
non-pseudo-random services being added.

On 1/4/2013 7:45 AM, Akinobu Mita wrote:
> 2013/1/4 Steve Wise <swise@opengridcomputing.com>:
>> Are there other "non pseudo-random" services that warrant this rename?
> I couldn't understand your question very well.  So I'm not sure this is
> the expected answer:
> I only renamed pseudo-random functions defined in lib/random32.c in the
> commit 496f2f93 ("random32: rename random32 to prandom").
> This patch series aims for finishing the naming transition and removing
> the backword compatibility wrapper macros.  Non pseudo-random functions
> are unrelated to this patch series.

