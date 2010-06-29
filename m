Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab0F2Rne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 13:43:34 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:33569 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab0F2Rnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 13:43:32 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 03/25] lmb: Print new doubled array location info
Date: Tue, 29 Jun 2010 11:44:13 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org> <1277227614-11581-4-git-send-email-yinghai@kernel.org>
In-Reply-To: <1277227614-11581-4-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006291144.14469.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010 11:26:32 am Yinghai Lu wrote:
> +	if (lmb_debug)
> +		pr_info("lmb: %s array is doubled to %ld at %llx - %llx",
> +			 lmb_type_name(type), type->max * 2, (u64)addr, (u64)addr + new_size);

Please print this memory range the same way we print resources, e.g.,
"%#010llx-%#010llx", with "addr" and "addr + new_size - 1".
