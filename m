Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab1LTFf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 00:35:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51002 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab1LTFfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 00:35:24 -0500
Message-ID: <4EF01E89.5000007@zytor.com>
Date: Mon, 19 Dec 2011 21:35:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, trenn@suse.de, kay.sievers@vrf.org,
        Andi Kleen <ak@linux.intel.com>, kay.sievers@vrfy.org, axboe@kernel.dk,
        ying.huang@intel.com
Subject: Re: [PATCH 03/10] crypto: Add support for x86 cpuid auto loading
 for x86 crypto drivers
References: <1324334865-30459-1-git-send-email-andi@firstfloor.org> <1324334865-30459-4-git-send-email-andi@firstfloor.org> <20111219232246.GB570@redhat.com> <4EEFC7D2.70803@zytor.com> <20111220040829.GD5637@one.firstfloor.org> <4EF014FE.4050101@zytor.com> <20111220053059.GA3108@gondor.apana.org.au>
In-Reply-To: <20111220053059.GA3108@gondor.apana.org.au>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 09:30 PM, Herbert Xu wrote:
> On Mon, Dec 19, 2011 at 08:54:22PM -0800, H. Peter Anvin wrote:
>>
>> What is really bad is that it doesn't tell you anywhere what it *is* using.
> 
> You can always check /proc/crypto to see what is currently
> registered.  The system will always choose the one with the
> highest priority out of those as the default.
> 

Yes, but it's ridiculous for it to list all the things I'm *not* using,
but not what I *am* using...

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

