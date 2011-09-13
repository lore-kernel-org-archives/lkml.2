Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab1IMOAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:00:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49945 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1IMOAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:00:50 -0400
Subject: Re: [patch 00/18] CFS Bandwidth Control v7.2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Paul Turner <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>,
        Jason Baron <jbaron@redhat.com>
Date: Tue, 13 Sep 2011 16:00:02 +0200
In-Reply-To: <1315915848.1151.26.camel@dhcp-10-30-22-158.sw.ru>
References: <20110721164325.231521704@google.com>
	 <1315915848.1151.26.camel@dhcp-10-30-22-158.sw.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1315922402.5977.10.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 16:10 +0400, Vladimir Davydov wrote:

> In other words, I'd like to know if your code (or the scheduler code)
> tries to gather all tasks of the same cgroup on such a subset of all
> CPUs 

No

> so that the tasks can't execute less CPUs without losing quota
> during each period. 

what?!

> And if not, are you going to address the issue? 

and no.

There is nothing special about being part of a cgroup that warrants
that, as for pipes the scheduler already tries to pull the waking task
to the cpu of the waker if possible (or an idle cache sibling).


