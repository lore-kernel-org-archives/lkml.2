Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab3ACRfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 12:35:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36087 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab3ACRfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 12:35:51 -0500
Message-ID: <50E5C167.2080908@zytor.com>
Date: Thu, 03 Jan 2013 09:35:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH -v2 03/26] x86: pageattr-test: remove srandom32 call
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com> <1357215562-6288-4-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1357215562-6288-4-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 04:18 AM, Akinobu Mita wrote:
> pageattr-test calls srandom32() once every test iteration.
> But calling srandom32() after late_initcalls is not meaningfull.
> Because the random states for random32() is mixed by good random numbers
> in late_initcall prandom_reseed().
>
> So this removes the call to srandom32().
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> ---
>
> No change from v1
>

Acked-by: H. Peter Anvin <hpa@zytor.com>

... for this and the other patch.  Do you need me to pick it up or are 
you pushing this directly as part of your bigger patchset?

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

