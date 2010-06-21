Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab0FUEpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 00:45:14 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:36750 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab0FUEpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 00:45:11 -0400
Message-ID: <4C1EEE54.9000902@in.ibm.com>
Date: Mon, 21 Jun 2010 10:15:08 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16178] 2.6.35-rc2 : OOPS with LTP memcg regression test
 run.
References: <lc60d4toGTL.A.QzD._LpHMB@chimera> <W8JfMs9cZw.A.O8F.UNpHMB@chimera>
In-Reply-To: <W8JfMs9cZw.A.O8F.UNpHMB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).
>   
This has been fixed by commit 386f40.
This was yet another instance of memory corruption caused by issue
related to ASCII while space pattern.

>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16178
> Subject		: 2.6.35-rc2 : OOPS with LTP memcg regression test run.
> Submitter	: Sachin Sant <sachinp@in.ibm.com>
> Date		: 2010-06-06 15:18 (15 days old)
> Message-ID	: <4C0BB98E.9030101@in.ibm.com>
> References	: http://marc.info/?l=linux-kernel&m=127583683912607&w=2
>
>
>   


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

