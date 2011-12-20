Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1LTEyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 23:54:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50788 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704Ab1LTEyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 23:54:46 -0500
Message-ID: <4EF014FE.4050101@zytor.com>
Date: Mon, 19 Dec 2011 20:54:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org, trenn@suse.de,
        kay.sievers@vrf.org, Andi Kleen <ak@linux.intel.com>,
        kay.sievers@vrfy.org, axboe@kernel.dk, herbert@gondor.hengli.com.au,
        ying.huang@intel.com
Subject: Re: [PATCH 03/10] crypto: Add support for x86 cpuid auto loading
 for x86 crypto drivers
References: <1324334865-30459-1-git-send-email-andi@firstfloor.org> <1324334865-30459-4-git-send-email-andi@firstfloor.org> <20111219232246.GB570@redhat.com> <4EEFC7D2.70803@zytor.com> <20111220040829.GD5637@one.firstfloor.org>
In-Reply-To: <20111220040829.GD5637@one.firstfloor.org>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 08:08 PM, Andi Kleen wrote:
>> The first printk is insanely annoying, because the end result is that we
>> get a printk of all the crypto engines that are *not* enabled...
>> arguably it would be somewhat nice to get a printk when a crypto engine
>> *is* enabled.
> 
> Yes that was my rationale. I have some Intel system complaining that
> some VIA crypto is not available. That's very annoying and just has
> to go.

What is really bad is that it doesn't tell you anywhere what it *is* using.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

