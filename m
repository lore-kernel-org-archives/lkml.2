Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab2EYRPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:15:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41835 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab2EYRPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:15:06 -0400
Message-ID: <4FBFBDCE.6030104@zytor.com>
Date: Fri, 25 May 2012 10:13:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thavatchai Makphaibulcboke <thavatchai.makpahibulchoke@hp.com>
CC: Lasse Collin <lasse.collin@tukaani.org>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kaloz@openwrt.org" <kaloz@openwrt.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>
Subject: Re: [PATCH] lib/decompress_unxz.c: removing all memory helper functions
References: <1337875436-27640-1-git-send-email-tmac@hp.com> <20120525113432.3beea6ed@tukaani.org> <4FBFB3F3.1000606@hp.com> <4FBFBBF3.3090204@hp.com>
In-Reply-To: <4FBFBBF3.3090204@hp.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 10:05 AM, Thavatchai Makphaibulcboke wrote:
>> We could do that.  But according to the comment in the original
>> implementation, there seems to be a concern regarding its performance
>> speed. If you believe all archs' memcpy would give comparable
>> performance to the memmove. then I could do that.
>>
> 
> Also how about the case for overlapping buffer, especially when the
> destination is at a higher address?  I do not believe memcpy guarantee
> to work.

memcpy() is not guaranteed to work for any overlap; that is what
memmove() is for.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

