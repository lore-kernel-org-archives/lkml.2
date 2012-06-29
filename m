Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab2F2TJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 15:09:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756250Ab2F2TJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 15:09:25 -0400
Message-ID: <4FEDFD0F.7070207@redhat.com>
Date: Fri, 29 Jun 2012 15:07:59 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hillf Danton <dhillf@gmail.com>,
        Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 21/40] autonuma: avoid CFS select_task_rq_fair to return
 -1
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>  <1340888180-15355-22-git-send-email-aarcange@redhat.com>  <4FEDFAB1.8050305@redhat.com> <1340996749.28750.125.camel@twins>
In-Reply-To: <1340996749.28750.125.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 03:05 PM, Peter Zijlstra wrote:
> On Fri, 2012-06-29 at 14:57 -0400, Rik van Riel wrote:
>> Either this is a scheduler bugfix, in which case you
>> are better off submitting it separately and reducing
>> the size of your autonuma patch queue, or this is a
>> behaviour change in the scheduler that needs better
>> arguments than a 1-line changelog.
>
> I've only said this like 2 or 3 times.. :/

I'll keep saying it until Andrea has fixed it :)

-- 
All rights reversed
