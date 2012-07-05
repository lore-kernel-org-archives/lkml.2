Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab2GEQku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:40:50 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34959 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab2GEQkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:40:49 -0400
Message-ID: <4FF5C064.3040107@us.ibm.com>
Date: Thu, 05 Jul 2012 09:27:16 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux@openhuawei.org
Subject: Re: [PATCH 0/3][RFC] Fix for leapsecond caused futex issue (v4)
References: <1341382890-42324-1-git-send-email-johnstul@us.ibm.com> <4FF3E178.7000806@us.ibm.com> <4FF5A79E.9030703@redhat.com>
In-Reply-To: <4FF5A79E.9030703@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070516-5806-0000-0000-000017018434
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 07:41 AM, Prarit Bhargava wrote:
> I tested this patchset for ~22 hours without any issues using my own leap second
> test code, John's previous leaptest.c and this new leap-a-day test with and
> without the -s option.
>
> In all x86 systems' cases (both AMD and Intel, large cpu count[1] and small cpu
> count) I also ran Firefox in the background and monitored it using top and
> occasionally breaking in to check the status of the futexes.  I haven't seen
> anything wrong with any of the systems.
>
> John, my apologies for not getting to exactly 24 hours.  I've usurped these
> systems long enough and other people need them :/.  I'm going to continue to run
> two systems (one AMD and one Intel) for a longer stretch but I don't anticipate
> any issues at this point.
>
> So ...
>
> Acked-by: Prarit Bhargava <prarit@redhat.com>
>
> For the entire patchset.
Thanks so much! I greatly appreciate the extra testing and review you've 
provided!

-john


