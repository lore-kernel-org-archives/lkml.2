Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab2DJRhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 13:37:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49249 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757641Ab2DJRhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 13:37:17 -0400
Message-ID: <4F846FBC.9060503@zytor.com>
Date: Tue, 10 Apr 2012 10:37:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
CC: x86@kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, linux-raid@vger.kernel.org
Subject: Re: arch/86: AVX RAID5 xor checksumming
References: <1334078551-6859-1-git-send-email-james.t.kukunas@linux.intel.com>
In-Reply-To: <1334078551-6859-1-git-send-email-james.t.kukunas@linux.intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 10:22 AM, Jim Kukunas wrote:
> Hi Folks,
> 
> The following patch adds an AVX implementation of the RAID5 xor checksumming
> functions.
> 
> Based on xor_speed, the AVX implementation appears to be ~32% faster than the
> SSE implementation on my i7 2600:
> 
>         generic_sse: 15088.000 MB/sec
> 	avx: 19936.000 MB/sec
> 
> Thanks.
> 

I think this (and the SSSE3 patches for RAID-6) should go in via the
RAID tree.  Neil, do you agree?

However,

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa

