Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab2BOR4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:56:47 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:33566 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2BOR4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:56:45 -0500
Date: Wed, 15 Feb 2012 23:26:36 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, pjt@google.com, efault@gmx.de, venki@google.com,
        suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: Re: sched: Performance of Trade workload running inside VM
Message-ID: <20120215175636.GE9918@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20120214112827.GA22653@linux.vnet.ibm.com>
 <1329307161.2293.66.camel@twins>
 <20120215171032.GB9918@linux.vnet.ibm.com>
 <1329326651.2293.151.camel@twins>
 <20120215173817.GD9918@linux.vnet.ibm.com>
 <1329327902.2293.168.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1329327902.2293.168.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12021507-0260-0000-0000-0000008B8082
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-02-15 18:45:02]:

> I'm still waiting for a problem description that isn't a book.

:-)

> What does the load-balancer do, why is it wrong, why does your patch
> sort it etc.

Ok. I will get some more load balancer traces and describe what it is doing
(potentially) wrong which is affecting this benchmark.

> I've really no idea what you're trying to do, other than make your
> numbers improve (which while a noble goal, doesn't help in judging your
> patch or suggesting alternative means of getting there).

- vatsa

