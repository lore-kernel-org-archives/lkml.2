Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab1C2Fhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 01:37:50 -0400
Received: from fornax3.0.iobloggo.com ([188.40.97.208]:44764 "EHLO
	mail.1.iobloggo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab1C2Fhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 01:37:50 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Mar 2011 01:37:49 EDT
Message-ID: <4D916EDA.6090402@cateee.net>
Date: Tue, 29 Mar 2011 07:32:10 +0200
From: Giacomo Catenazzi <cate@cateee.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Icedove/3.0.11
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Mike Snitzer <snizer@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Regression] Please revert a91a2785b20
References: <alpine.LFD.2.00.1103290006070.2774@localhost6.localdomain6>	<yq1hbamkgoe.fsf@sermon.lab.mkp.net>	<alpine.LFD.2.00.1103290049330.2774@localhost6.localdomain6> <yq1d3lakct3.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1d3lakct3.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 02:09 AM, Martin K. Petersen wrote:
>>>>>> "Thomas" == Thomas Gleixner <tglx@linutronix.de> writes:
> 
> Thomas> Why didn't you send a revert to Linus right away?
> 
> Simply didn't think of it. Didn't get the bug report until this
> afternoon and few people build with BLK_DEV_INTEGRITY enabled. But I
> guess Fedora has it on by default.

BTW I've BLK_DEV_INTEGRITY disabled, so I'm confused with your analysis.

Anyway your patch solve the problem on my system.

ciao
	cate
