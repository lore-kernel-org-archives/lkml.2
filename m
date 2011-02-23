Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab1BWU76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:59:58 -0500
Received: from usmamail.tilera.com ([206.83.70.70]:59698 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab1BWU74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:59:56 -0500
Message-ID: <4D65754B.7010608@tilera.com>
Date: Wed, 23 Feb 2011 15:59:55 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <linux-mm@kvack.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 01/25] tile: Fix __pte_free_tlb
References: <20110125173111.720927511@chello.nl>	 <20110125174907.220115681@chello.nl>  <4D4C63ED.6060104@tilera.com> <1297086911.13327.17.camel@laptop>
In-Reply-To: <1297086911.13327.17.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/2011 8:55 AM, Peter Zijlstra wrote:
> On Fri, 2011-02-04 at 15:39 -0500, Chris Metcalf wrote:
>> On 1/25/2011 12:31 PM, Peter Zijlstra wrote:
>>> Tile's __pte_free_tlb() implementation makes assumptions about the
>>> generic mmu_gather implementation, cure this ;-)
>> I assume you will take this patch into your tree?  If so:
>>
>> Acked-by: Chris Metcalf <cmetcalf@tilera.com>
> Feel free to take it yourself, this series might take a while to land..

Thanks, I took it into my tree (without the comment about the on-stack array).

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

