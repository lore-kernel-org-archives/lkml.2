Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab2EXRbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:31:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56388 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab2EXRbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:31:44 -0400
Message-ID: <4FBE6FF6.5090904@zytor.com>
Date: Thu, 24 May 2012 10:29:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: T Makphaibulchoke <tmac@hp.com>, lethal@linux-sh.org, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, kaloz@openwrt.org,
        matt.fleming@intel.com, lasse.collin@tukaani.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux@arm.linux.org.uk, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, linux390@de.ibm.com
Subject: Re: [PATCH] lib/decompress_unxz.c: removing all memory helper functions
References: <1337875436-27640-1-git-send-email-tmac@hp.com> <1337880371.5070.24.camel@joe2Laptop>
In-Reply-To: <1337880371.5070.24.camel@joe2Laptop>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 10:26 AM, Joe Perches wrote:
> On Thu, 2012-05-24 at 10:03 -0600, T Makphaibulchoke wrote:
>> The patch cleans up the file lib/decompress_unxz.c by removing all memory
>> helper functions, e.g., memmove.  By doing so, any architecture's preboot
>> environment supporting the XZ decompression needs to define its own copy of
>> any of the missing memory helper functions.
> 
> Perhaps a silly question, but why not use
> the __builtin variants?

For a lot of cases the __builtin variants just generate a call to the
expected out-of-line function, so you need it anyway.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

