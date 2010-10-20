Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0JTFhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 01:37:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab0JTFhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 01:37:07 -0400
Message-ID: <4CBE80F1.5080003@redhat.com>
Date: Wed, 20 Oct 2010 13:41:05 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Andreas Schwab <schwab@redhat.com>, linux-kernel@vger.kernel.org,
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
References: <1287476560-5874-1-git-send-email-amwang@redhat.com>	<1287476560-5874-2-git-send-email-amwang@redhat.com>	<4CBD9B7F.6040307@linux.intel.com> <m3lj5uff3h.fsf@hase.home> <4CBDB3B0.8080605@linux.intel.com>
In-Reply-To: <4CBDB3B0.8080605@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/10 23:05, Andi Kleen wrote:
> On 10/19/2010 4:10 PM, Andreas Schwab wrote:
>>> On 10/19/2010 10:22 AM, Amerigo Wang wrote:
>>>> Remove the obsolete sysctl syscall. It was scheduled
>>>> to be removed in Sept.
>>>
>>> I thought at least older glibc was still using it? Did anyone check
>>> what happens if it sees no sysctl(2)?
>> It will fall back reading from /proc/sys.
>
> First that's slow (but ok), but that will fail if there is no /proc.
>

I strongly doubt glibc will work if there is no /proc,
a quick grep shows lots of "/proc" strings in glibc code.
