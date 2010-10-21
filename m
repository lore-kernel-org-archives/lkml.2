Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab0JUGKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 02:10:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59632 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab0JUGKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 02:10:09 -0400
Message-ID: <4CBFD92B.5090503@zytor.com>
Date: Wed, 20 Oct 2010 23:09:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
Subject: Re: [tip:x86/mm] percpu: Introduce a read-mostly percpu API
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>	 <tip-c957ef2c59e952803766ddc22e89981ab534606f@git.kernel.org>	 <20101021013833.GA21863@sli10-conroe.sh.intel.com>	 <1287639230.2545.117.camel@edumazet-laptop>  <4CBFD5A6.3060308@zytor.com> <1287641277.4507.23.camel@edumazet-laptop>
In-Reply-To: <1287641277.4507.23.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2010 11:07 PM, Eric Dumazet wrote:
> Le mercredi 20 octobre 2010 à 22:54 -0700, H. Peter Anvin a écrit :
> 
>> L1_CACHE_BYTES is completely pointless, since if there is sharing to
>> worry about *at all*, it's probably at the L2 or L3 cache levels.
>>
> 
> I see, and we dont have better way to express this hint/requirement than
> using PAGE_SIZE or INTERNODE_CACHE_SHIFT ?
> 
> In your patch you force a PAGE_SIZE alignement *before*
> *(.data..percpu..page_aligned)   
> 
> If this alignment is really needed, this should be part of another
> patch, since this fixes a previous bug in 2.6.36 ?
> 

It was part of Shaohua's patch... I don't know if it does anything
useful, but it also doesn't hurt.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

