Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab0JSOK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:10:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0JSOK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:10:57 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Len Brown <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Eric Paris <eparis@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] sysctl: remove sysctl syscall
References: <1287476560-5874-1-git-send-email-amwang@redhat.com>
	<1287476560-5874-2-git-send-email-amwang@redhat.com>
	<4CBD9B7F.6040307@linux.intel.com>
X-Yow: MMM-MM!!  So THIS is BIO-NEBULATION!
Date: Tue, 19 Oct 2010 16:10:26 +0200
In-Reply-To: <4CBD9B7F.6040307@linux.intel.com> (Andi Kleen's message of "Tue,
	19 Oct 2010 15:22:07 +0200")
Message-ID: <m3lj5uff3h.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@linux.intel.com> writes:

>  On 10/19/2010 10:22 AM, Amerigo Wang wrote:
>> Remove the obsolete sysctl syscall. It was scheduled
>> to be removed in Sept.
>
>
> I thought at least older glibc was still using it? Did anyone check
> what happens if it sees no sysctl(2)?

It will fall back reading from /proc/sys.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
