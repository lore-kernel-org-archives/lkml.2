Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab0DVI06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 04:26:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab0DVI04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 04:26:56 -0400
Message-ID: <4BD00928.5010909@redhat.com>
Date: Thu, 22 Apr 2010 16:30:32 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: Fix OOPS in crash_kernel_shrink
References: <87iq7n8toc.wl%vmayatsk@redhat.com>	<4BCDA46E.9030405@redhat.com> <87r5maqleh.wl%vmayatsk@redhat.com>
In-Reply-To: <87r5maqleh.wl%vmayatsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Mayatskikh wrote:
> At Tue, 20 Apr 2010 20:56:14 +0800, Cong Wang wrote:
>> Vitaly Mayatskikh wrote:
>>> Two "echo 0 > /sys/kernel/kexec_crash_size" OOPSes kernel. Also
>>> content of this file is invalid after first shrink to zero: it shows 1
>>> instead of 0.
>>>
>>> This patch fixes it.
>> Hmmm, I certainly did tests for 'echo 0 > kexec_crash_size' when I
>> worked on this, but I didn't get any oops. Can you show me the full
>> oops?
> 
> Do it twice. start == end condition will work over and over, and
> kernel will try to release_resource() again (and that's causes OOPS).
> 

Hmm, I see. ACK to your patch.

Thanks much!

