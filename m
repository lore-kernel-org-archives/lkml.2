Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab1BWHvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 02:51:35 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:40991 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab1BWHvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 02:51:31 -0500
Date: Wed, 23 Feb 2011 13:21:21 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>
Subject: Re: [CFS Bandwidth Control v4 0/7] Introduction
Message-ID: <20110223075121.GI3379@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110216031831.571628191@google.com>
 <4D61D230.907@cn.fujitsu.com>
 <AANLkTinyZSeTQd9t9wCp+LMZ+gGM4H0mZBc+daZgnZ5u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTinyZSeTQd9t9wCp+LMZ+gGM4H0mZBc+daZgnZ5u@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Turner <pjt@google.com> [2011-02-22 23:42:48]:

> Thanks for the report Xiao -- I wasn't able to reproduce this yet with
> a simple guest, I will try a more modern image tomorrow.
> 
> One suspicion is that this might be connected with the missing
> runnable accounting in sched_stoptask.c.
>

I can confirm that, my guests work fine after the changes posted this
morning. I still see some lockdep errors, but none associated with the
scheduler. 

-- 
	Three Cheers,
	Balbir
