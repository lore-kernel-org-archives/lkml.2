Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab1ITR3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:29:46 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:37157 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab1ITR3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:29:45 -0400
Date: Tue, 20 Sep 2011 22:59:30 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, jbottomley@parallels.com
Subject: Re: [PATCH 1/9] Remove parent field in cpuacct cgroup
Message-ID: <20110920172930.GA5318@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
 <1316030695-19826-2-git-send-email-glommer@parallels.com>
 <1316448186.1511.19.camel@twins>
 <4E776937.1070108@parallels.com>
 <1316449160.6091.5.camel@twins>
 <4E776E36.6040906@parallels.com>
 <1316450385.6091.9.camel@twins>
 <4E7770BD.6050902@parallels.com>
 <1316457653.6091.16.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1316457653.6091.16.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-19 20:40:53]:

> > Note I was talking about cpuusage. Well, in this case, I myself fail
> > to see the value of the whole cpuusage thing...

If I recall, cpuacct was prototyped by Paul Menage (and later modified
by Balbir) as a way to demonstrate cgroup controller ..It was one 
of those "first" cgroups controllers written to demonstrate how cgroups worked.

With regard to its value, it does provide a handy interface to measure
cpu utilization of cgroups (vs having to manually sum up task's
utilization) and afaik libvirt makes use of it (although I
don't think anyone reads it at "high" frequency).

http://www.redhat.com/archives/libvir-list/2011-April/msg00801.html

> >  Someone that sees 
> > further could maybe help us out here? (but this is sideways to the whole 
> > discussion we're having anyway)
> 
> Would probably do to cc the cpuacct authors in this patch set ;-) I
> think it came from IBM, so I added vatsa.

- vatsa
