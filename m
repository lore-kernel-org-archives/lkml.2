Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1LVK6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 05:58:41 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40156 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab1LVK6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 05:58:40 -0500
Message-ID: <4EF30D4B.9060906@linux.vnet.ibm.com>
Date: Thu, 22 Dec 2011 16:28:19 +0530
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
        Belisko Marek <marek.belisko@gmail.com>,
        Jeff Layton <jlayton@redhat.com>, awilliam@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: Re: [Resend] 3.2-rc6+: Reported regressions from 3.0 and 3.1
References: <201112210054.46995.rjw@sisk.pl>
In-Reply-To: <201112210054.46995.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11122200-5140-0000-0000-000000753013
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

[...]

> 
> Subject    : Freezing of tasks failed after 20.01 seconds in kernel 3.2.0-rc2
> Submitter  : Belisko Marek <marek.belisko@gmail.com>
> Date       : 2011-11-22 21:20
> Message-ID : 
> CAAfyv36nxYq1EA2pcHi5WR1BdWYHp2sQTY1mMA4Q3JjcOG5RDw@mail.gmail.com
> References : http://marc.info/?l=linux-kernel&m=132199691706100&w=2
> 
>


I believe we already have a fix for this, but not yet in mainline:
http://thread.gmane.org/gmane.linux.nfs/45336

Regards,
Srivatsa S. Bhat

