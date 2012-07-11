Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab2GKMQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:16:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab2GKMQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:16:16 -0400
Message-ID: <4FFD6E84.7000702@redhat.com>
Date: Wed, 11 Jul 2012 08:16:04 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH 0/6] Fix for leapsecond caused hrtimer/futex issue (updated)
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/10/2012 06:43 PM, John Stultz wrote:
> Over the weekend, Thomas got a chance to review the leap second fix
> in more detail and had a few additional changes he wanted to make
> to improve performance as well as style.
> 
> So this iteration includes his modifications.
> 
> Once merged, I'll be working to get the backports finished as quickly
> as I can and sent to -stable.
> 
> thanks
> -john
> 

Add an Acked-by: Prarit Bhargava <prarit@redhat.com>

John -- I'll do some testing of this patchset today and tomorrow and let you
know the results.

P.
