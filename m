Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab2FNQQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:16:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36191 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756356Ab2FNQQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:16:56 -0400
Message-ID: <4FDA0E3F.3030603@zytor.com>
Date: Thu, 14 Jun 2012 09:15:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: nicolas.pitre@linaro.org, linux-s390@vger.kernel.org,
        matt.fleming@intel.com, lasse.collin@tukaani.org, jj@chaosbits.net,
        linux-sh@vger.kernel.org, x86@kernel.org, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, lethal@linux-sh.org,
        T Makphaibulchoke <tmac@hp.com>, schwidefsky@de.ibm.com,
        linux390@de.ibm.com, tglx@linutronix.de, kaloz@openwrt.org,
        mingo@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] lib/decompress_unxz.c: removing all memory helper
 functions
References: <1339470307-28223-1-git-send-email-tmac@hp.com> <4FD6B472.7040609@zytor.com> <20120612143545.GC7918@n2100.arm.linux.org.uk> <20120614134715.GE28714@n2100.arm.linux.org.uk> <4FD9F6AD.6060407@zytor.com> <20120614154414.GA7628@n2100.arm.linux.org.uk>
In-Reply-To: <20120614154414.GA7628@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 08:44 AM, Russell King - ARM Linux wrote:
>>>
>>> Okay, given the issue raised with memcpy() calling __builtin_memcpy(),
>>> I don't think there's any value to me actually testing this, because
>>> that seems to need to be solved first?
>>
>> You mean __builtin_memcpy() calling memcpy(), right?
> 
> Indeed I do.

Right... that would manifest itself as a build failure, but it needs to
be fixed, so...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

