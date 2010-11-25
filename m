Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab0KYJTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 04:19:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab0KYJTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 04:19:01 -0500
Message-ID: <4CEE29F6.1010003@redhat.com>
Date: Thu, 25 Nov 2010 11:18:46 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Gleb Natapov <gleb@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: write protect memory after slot swap
References: <20101025012124.GA31262@redhat.com> <4CC54EB8.9020604@redhat.com> <4CED649B.5000805@siemens.com>
In-Reply-To: <4CED649B.5000805@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 09:16 PM, Jan Kiszka wrote:
> >
> >  Excellent catch, I stared at this code for a while and didn't see the
> >  bug.  Patch applied.
> >
>
> This patch was marked KVM-stable on commit, but it did not make into any
> stable branch thus also none of the recent releases. Please fix (for
> 2.6.36 now).

We need some bot that watches out for commits with the tag going into 
upstream and pokes the maintainers.

-- 
error compiling committee.c: too many arguments to function

