Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab0F2Sw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:52:59 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:43146 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab0F2Sw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:52:57 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 03/25] lmb: Print new doubled array location info
Date: Tue, 29 Jun 2010 12:48:46 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org> <201006291144.14469.bjorn.helgaas@hp.com> <4C2A3DB4.70308@zytor.com>
In-Reply-To: <4C2A3DB4.70308@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006291248.48191.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 29, 2010 12:38:44 pm H. Peter Anvin wrote:
> On 06/29/2010 10:44 AM, Bjorn Helgaas wrote:
> > On Tuesday, June 22, 2010 11:26:32 am Yinghai Lu wrote:
> >> +	if (lmb_debug)
> >> +		pr_info("lmb: %s array is doubled to %ld at %llx - %llx",
> >> +			 lmb_type_name(type), type->max * 2, (u64)addr, (u64)addr + new_size);
> > 
> > Please print this memory range the same way we print resources, e.g.,
> > "%#010llx-%#010llx", with "addr" and "addr + new_size - 1".
> 
> *Ten* hex digits?

I think that width includes the "0x" prefix, so it's really eight digits.
