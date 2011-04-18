Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1DRBqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 21:46:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:46164 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab1DRBqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 21:46:24 -0400
Subject: Re: mm: convert vma->vm_flags to 64bit
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <alpine.LSU.2.00.1104171649350.21405@sister.anvils>
References: <20110412151116.B50D.A69D9226@jp.fujitsu.com>
	 <alpine.LSU.2.00.1104171649350.21405@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 11:45:39 +1000
Message-ID: <1303091139.28876.152.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-17 at 17:26 -0700, Hugh Dickins wrote:
> I am surprised that
> #define VM_EXEC         0x00000004ULL
> does not cause trouble for arch/arm/kernel/asm-offsets.c,
> but you tried cross-building it which I never did.

It would probably cause trouble for a big endian ARM no ? In that case
it should offset the load by 4.

> Does your later addition of __nocast on vm_flags not make trouble
> for the unsigned long casts in arch/arm/include/asm/cacheflush.h?
> (And if it does not, then just what does __nocast do?)
> 
> Thanks for seeing this through, 

Cheers,
Ben.

