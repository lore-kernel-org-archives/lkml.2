Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1LVSrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:47:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55938 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab1LVSrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:47:16 -0500
Date: Thu, 22 Dec 2011 10:47:10 -0800
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
Message-ID: <20111222184710.GJ17084@google.com>
References: <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
 <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
 <20111220162315.GC10752@google.com>
 <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com>
 <20111220202854.GH10752@google.com>
 <alpine.DEB.2.00.1112210851230.9601@router.home>
 <20111221170535.GB9213@google.com>
 <alpine.DEB.2.00.1112220854440.31315@router.home>
 <20111222160822.GE17084@google.com>
 <alpine.DEB.2.00.1112221154380.11787@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112221154380.11787@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 11:58:51AM -0600, Christoph Lameter wrote:
> Subject: [percpu] Remove irqsafe_cpu_xxx variants
> 
> We simply say that regular this_cpu use must be safe regardless of preemption
> and interrupt state. That has no material change for x86 and s390 implementations
> of this_cpu operations. However, arches that do not provide their own implementation
> for this_cpu operations will now get code generated that disables interrupts
> instead of preemption.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to wq/for-3.3.

Thanks.

-- 
tejun
