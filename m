Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515Ab2EWQML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:12:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41828 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab2EWQMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:12:09 -0400
Message-ID: <4FBD0C47.70600@zytor.com>
Date: Wed, 23 May 2012 09:11:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, frank.arnold@amd.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, borislav.petkov@amd.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
References: <1337684026-19740-1-git-send-email-bp@amd64.org>  <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org> <1337789429.9783.16.camel@laptop>
In-Reply-To: <1337789429.9783.16.camel@laptop>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 09:10 AM, Peter Zijlstra wrote:
> On Wed, 2012-05-23 at 09:07 -0700, tip-bot for Borislav Petkov wrote:
>> +#define BIT_64(n)                      (U64_C(1) << (n))
> 
> Because writing 1ULL << n is too much work? 
> 

Because writing 1ULL << n is broken in anything that needs to be used in
assembly, for example.

	-hpa


