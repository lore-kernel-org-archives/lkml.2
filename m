Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab0DMEdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 00:33:32 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:29120 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab0DMEda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 00:33:30 -0400
Message-ID: <4BC3F3B1.9020000@oracle.com>
Date: Mon, 12 Apr 2010 21:31:45 -0700
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
Subject: Re: [PATCH 06/39] lmb: Seperate __lmb_find_base() from __lmb_alloc_base()
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>	 <1270793048-23796-7-git-send-email-yinghai@kernel.org> <1271131081.13059.51.camel@pasglop>
In-Reply-To: <1271131081.13059.51.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BC3F402.0024:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 08:58 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-04-08 at 23:03 -0700, Yinghai Lu wrote:
> 
>> +	return -1ULL;
>> +}
> 
> Defininf some kind of LMB_ERROR would be nicer.

ok, also __lmb_alloc_base could return 0 when fail to get one.

replace that 0 with LMB_ERROR aka -1ULL?

Yinghai
