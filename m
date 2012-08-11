Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab2HKSgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 14:36:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60727 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738Ab2HKSgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 14:36:43 -0400
Message-ID: <5026A637.2070104@zytor.com>
Date: Sat, 11 Aug 2012 11:36:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 1/5] x86: Only direct map addresses that are marked as
 E820_RAM
References: <1344547389-4599-1-git-send-email-jacob.shin@amd.com> <1344547389-4599-2-git-send-email-jacob.shin@amd.com> <CAE9FiQXiSq=5VQ5nNELPjDkj0QRjA=sbKfPwAeVDADteY-vdyw@mail.gmail.com>
In-Reply-To: <CAE9FiQXiSq=5VQ5nNELPjDkj0QRjA=sbKfPwAeVDADteY-vdyw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 03:03 PM, Yinghai Lu wrote:
>
> can you put those line in another function?
>
> setup_arch is way too big now.
>

I agree with this ... Jacob, could you rev the patch?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

