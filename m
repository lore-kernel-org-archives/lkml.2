Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab1LVLPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 06:15:42 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:36524 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab1LVLPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 06:15:40 -0500
Message-ID: <4EF3114C.6020406@linux.vnet.ibm.com>
Date: Thu, 22 Dec 2011 16:45:24 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>, davem@davemloft.net,
        "pavel@ucw.cz" <pavel@ucw.cz>, Chris Ball <cjb@laptop.org>,
        manuel.lauss@googlemail.com, Udo Steinberg <udo@hypervisor.org>
Subject: Re: [Resend] 3.2-rc6+: Reported regressions from 3.0 and 3.1
References: <201112210054.46995.rjw@sisk.pl>
In-Reply-To: <201112210054.46995.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11122201-1396-0000-0000-0000006E707C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 05:24 AM, Rafael J. Wysocki wrote:

> [Evidently, vger has blocked the previous attempts to post this message
> for some reason.  I wonder why?]
> 
> This message contains a list of some regressions from 3.0 and 3.1
> for which there are no fixes in the mainline known to the tracking team.
> If any of them have been fixed already, please let us know.
> 
> If you know of any other unresolved regressions from 3.0 and 3.1, please let us
> know either and we'll add them to the list.  Also, please let us know if any of
> the entries below are invalid.
> 
> The entries below are simplified and the statistics are not present due to the
> continuing Bugzilla outage.
> 
> 
> Subject    : 3.2-rc2: regression after hibernate: lots of warnings, broken 
> system
> Submitter  : Pavel Machek <pavel@ucw.cz>
> Date       : 2011-11-24 15:40
> Message-ID : 20111124154014.GA2153@elf.ucw.cz
> References : http://marc.info/?l=linux-kernel&m=132214929818015&w=2
> 


This one looks a bit similar to the one reported at
http://thread.gmane.org/gmane.linux.kernel/1230509/ which is fixed by
commit 29495aa04a30c21565243c5b9c028510446d242c.

 

Regards,
Srivatsa S. Bhat

