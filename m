Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1LURJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:09:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63514 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1LURJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:09:46 -0500
Date: Wed, 21 Dec 2011 09:09:40 -0800
From: Tejun Heo <tj@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
Message-ID: <20111221170940.GC9213@google.com>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
 <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
 <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
 <20111220162315.GC10752@google.com>
 <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com>
 <20111220202854.GH10752@google.com>
 <CAOJsxLE55zXt_PCmvyykP_-W26AHXOJ+zEPs3EVC-Xqazwn2tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLE55zXt_PCmvyykP_-W26AHXOJ+zEPs3EVC-Xqazwn2tQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 21, 2011 at 10:08:48AM +0200, Pekka Enberg wrote:
> Sure but well-defined semantics alone are not sufficient for a
> reasonable API. It's not at all obvious which one of the four variants
> to pick when writing code. I don't see any evidence that people
> actually understand the API. On the contrary, I see bugs caused by API
> confusion in mm/slub.c itself!

Sure, I agree.  If nobody beats me to it, I'll try to clean it up for
the merge window after the coming one (ie. 3.4).  But please feel free
to submit patches to gut out cruft and clean up.  I'll be happy to
apply them.

Thanks.

-- 
tejun
