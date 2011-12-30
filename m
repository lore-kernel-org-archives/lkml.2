Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab1L3Jxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 04:53:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38915 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab1L3Jxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 04:53:49 -0500
Date: Fri, 30 Dec 2011 10:51:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
Message-ID: <20111230095147.GA10543@elte.hu>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
 <20111219112326.GA15090@elte.hu>
 <87sjke1a53.fsf@abhimanyu.in.ibm.com>
 <4EF1B85F.7060105@redhat.com>
 <877h1o9dp7.fsf@linux.vnet.ibm.com>
 <20111223103620.GD4749@elte.hu>
 <4EF701C7.9080907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF701C7.9080907@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> [...]
> 
> The first part appears to be unrelated to ebizzy itself - it's 
> the kunmap_atomic() flushing ptes.  It could be eliminated by 
> switching to a non-highmem kernel, or by allocating more PTEs 
> for kmap_atomic() and batching the flush.

Nikunj, please only run pure 64-bit/64-bit combinations - by the 
time any fix goes upstream and trickles down to distros 32-bit 
guests will be even less relevant than they are today.

Thanks,

	Ingo
