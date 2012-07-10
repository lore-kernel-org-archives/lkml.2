Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2GJWyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:54:44 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55480 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab2GJWym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:54:42 -0400
Message-ID: <4FFCB287.80701@us.ibm.com>
Date: Tue, 10 Jul 2012 15:53:59 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH 0/6] Fix for leapsecond caused hrtimer/futex issue (updated)
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071022-7606-0000-0000-000001E6A362
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 03:43 PM, John Stultz wrote:
> Over the weekend, Thomas got a chance to review the leap second fix
> in more detail and had a few additional changes he wanted to make
> to improve performance as well as style.
>
> So this iteration includes his modifications.
>
> Once merged, I'll be working to get the backports finished as quickly
> as I can and sent to -stable.

Also, Thomas pointed out that the entire fix might be too large for this 
late in the -rc cycle.

Thus we may want to merge only the first two patches as the "simple fix" 
which will avoid the major problems seen for 3.5, and then leave the 
last four patches, which really enforce correctness, for 3.6 merge 
window (backporting variants  to -stable).

But I'll leave that to Thomas/Ingo/Linus to decide.

thanks
-john

