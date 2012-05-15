Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab2EOAeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 20:34:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61019 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab2EOAd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 20:33:59 -0400
Date: Mon, 14 May 2012 17:33:56 -0700 (PDT)
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
In-Reply-To: <20120513231638.3566.30867.stgit@srivatsabhat>
Message-ID: <alpine.DEB.2.00.1205141732570.25235@chino.kir.corp.google.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231638.3566.30867.stgit@srivatsabhat>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Srivatsa S. Bhat wrote:

> Cpusets needs to distinguish between a regular CPU Hotplug operation and a
> CPU Hotplug operation carried out as part of the suspend/resume sequence.
> So add provisions to facilitate that, so that the two operations can be
> handled differently.
> 

There's no functional change with this patch and it's unclear from this 
changelog why we need to distinguish between the two, so perhaps fold this 
into patch 5 or explain how this will be helpful in this changelog?  
Otherwise it doesn't seem justifiable to add 30 more lines of code.
