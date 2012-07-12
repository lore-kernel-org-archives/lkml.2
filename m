Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193Ab2GLMdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:33:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758946Ab2GLMdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:33:07 -0400
Message-ID: <4FFEC3F0.3060800@redhat.com>
Date: Thu, 12 Jul 2012 08:32:48 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH 0/6] Fix for leapsecond caused hrtimer/futex issue (updated)
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com> <20120711111728.GA19242@gmail.com>
In-Reply-To: <20120711111728.GA19242@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/11/2012 07:17 AM, Ingo Molnar wrote:
> 
> * John Stultz <johnstul@us.ibm.com> wrote:
> 
>> Over the weekend, Thomas got a chance to review the leap 
>> second fix in more detail and had a few additional changes he 
>> wanted to make to improve performance as well as style.


John,

FYI -- Using a mix of AMD and Intel systems (big and small, large memory and
small memory footprint), current test runs are ~18 hours at this point without
any issues seen, using a slightly modified version of your leap-a-day.c .

P.
