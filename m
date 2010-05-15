Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab0EOANI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 20:13:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52108 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab0EOANF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 20:13:05 -0400
Message-ID: <4BEDE6A4.4050505@oracle.com>
Date: Fri, 14 May 2010 17:11:16 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 07/37] lmb: Add lmb_find_area()
References: <1273866363-14249-1-git-send-email-yinghai@kernel.org>	 <1273866363-14249-8-git-send-email-yinghai@kernel.org> <1273876749.21352.645.camel@pasglop> <4BEDD7D4.90002@oracle.com>
In-Reply-To: <4BEDD7D4.90002@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4BEDE6FB.0022:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2010 04:08 PM, Yinghai wrote:
> On 05/14/2010 03:39 PM, Benjamin Herrenschmidt wrote:
>>
>> I might have accepted that one if you had called it something like
>> lmb_find_in_range() which at least -means- something.
> 
> thanks. will use sed to replace them.
> 
> lmb_find_area ==> lmb_find_in_range()
> 

updated version is in

	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git lmb

it is on top of tip/master + powerpc/lmb

Thanks

Yinghai
