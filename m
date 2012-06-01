Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965701Ab2FASrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:47:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42919 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965617Ab2FASrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:47:31 -0400
Message-ID: <4FC90E00.7010100@zytor.com>
Date: Fri, 01 Jun 2012 11:46:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thavatchai Makphaibulcboke <thavatchai.makpahibulchoke@hp.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kaloz@openwrt.org" <kaloz@openwrt.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "lasse.collin@tukaani.org" <lasse.collin@tukaani.org>,
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
References: <1337875436-27640-1-git-send-email-tmac@hp.com> <20120528070336.GM3377@game.jcrosoft.org> <4FC82D89.1040108@hp.com> <4FC83940.9010708@zytor.com> <4FC90C01.2060005@hp.com>
In-Reply-To: <4FC90C01.2060005@hp.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 11:37 AM, Thavatchai Makphaibulcboke wrote:
> On 05/31/2012 09:38 PM, H. Peter Anvin wrote:
>> We could always make a source code library, like we already in effect
>> have for the compression functions themselves.
>>
>> 	-hpa
>>
> 
> Thanks for the suggestion and comment.  I guess we could add a new
> directory with a new file under arch, such as arch/lib/mem.c and use the
> source include similar to the compression.
> 

Well, the decompression stuff is under lib/ ... maybe lib/boot/ or
something like that...

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

