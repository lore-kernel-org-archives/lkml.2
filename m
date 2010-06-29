Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab0F2Sjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:39:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33258 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab0F2Sjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:39:35 -0400
Message-ID: <4C2A3DB4.70308@zytor.com>
Date: Tue, 29 Jun 2010 11:38:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 03/25] lmb: Print new doubled array location info
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org> <1277227614-11581-4-git-send-email-yinghai@kernel.org> <201006291144.14469.bjorn.helgaas@hp.com>
In-Reply-To: <201006291144.14469.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2010 10:44 AM, Bjorn Helgaas wrote:
> On Tuesday, June 22, 2010 11:26:32 am Yinghai Lu wrote:
>> +	if (lmb_debug)
>> +		pr_info("lmb: %s array is doubled to %ld at %llx - %llx",
>> +			 lmb_type_name(type), type->max * 2, (u64)addr, (u64)addr + new_size);
> 
> Please print this memory range the same way we print resources, e.g.,
> "%#010llx-%#010llx", with "addr" and "addr + new_size - 1".

*Ten* hex digits?

	-hpa
