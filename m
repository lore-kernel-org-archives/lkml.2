Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab2EOSeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:34:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57167 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933320Ab2EOSer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:34:47 -0400
Date: Tue, 15 May 2012 11:34:44 -0700 (PDT)
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
In-Reply-To: <4FB24C36.7000702@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1205151133450.24304@chino.kir.corp.google.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231638.3566.30867.stgit@srivatsabhat> <alpine.DEB.2.00.1205141732570.25235@chino.kir.corp.google.com> <4FB24C36.7000702@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012, Srivatsa S. Bhat wrote:

> >> Cpusets needs to distinguish between a regular CPU Hotplug operation and a
> >> CPU Hotplug operation carried out as part of the suspend/resume sequence.
> >> So add provisions to facilitate that, so that the two operations can be
> >> handled differently.
> >>
> > 
> > There's no functional change with this patch and it's unclear from this 
> > changelog why we need to distinguish between the two, so perhaps fold this 
> > into patch 5 or explain how this will be helpful in this changelog?  
> > Otherwise it doesn't seem justifiable to add 30 more lines of code.
> 
> 
> Well, as 0/5 explains, this whole patchset is a suspend/resume-only fix.
> So we need special-case handling for suspend/resume in cpusets. So the
> additional code is justified, IMHO. It prepares the ground for patch 5.
> 

Your change, once merged, will not carry patch 0/5 here, so it would be 
helpful to understand why we need to distinguish between the two as a 
stand-alone patch in your changelog.
