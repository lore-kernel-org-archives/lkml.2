Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966773Ab2EOUkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:40:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39926 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966237Ab2EOUj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:39:59 -0400
Date: Tue, 15 May 2012 13:39:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org, rjw@sisk.pl,
        nacc@us.ibm.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 4/5] cpusets: Add provisions for distinguishing CPU
 Hotplug in suspend/resume path
In-Reply-To: <4FB2ABD0.4000104@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1205151338120.583@chino.kir.corp.google.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231638.3566.30867.stgit@srivatsabhat> <alpine.DEB.2.00.1205141732570.25235@chino.kir.corp.google.com> <4FB24C36.7000702@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151133450.24304@chino.kir.corp.google.com>
 <4FB2ABD0.4000104@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012, Srivatsa S. Bhat wrote:

> > Your change, once merged, will not carry patch 0/5 here, so it would be 
> > helpful to understand why we need to distinguish between the two as a 
> > stand-alone patch in your changelog.
> > 
> 
> 
> Sorry, I didn't quite get your point. Do you just want me to update this
> changelog or do you still want me to squash this patch with patch 5?
> 

I think it should either be folded into patch 5 or the changelog updated 
to reflect why we need to distinguish between hotplug and suspend; the 
text from patch 0 will not be carried along to git so as a stand-alone 
commit in Linus' tree, it's confusing why this is being done.
