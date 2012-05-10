Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab2EJQaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:30:12 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:44054 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184Ab2EJQaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:30:05 -0400
Date: Thu, 10 May 2012 12:29:40 -0400 (EDT)
From: Igor Mammedov <imammedo@redhat.com>
To: shuahkhan@gmail.com
Cc: linux-kernel@vger.kernel.org, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, luto@mit.edu,
        suresh b siddha <suresh.b.siddha@intel.com>, avi@redhat.com,
        a p zijlstra <a.p.zijlstra@chello.nl>, johnstul@us.ibm.com,
        arjan@linux.intel.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/5] Fix soft-lookup in stop machine on secondary cpu bring up
Message-ID: <8c0f597c-b2a7-4599-9d9f-c4c81412318a@zmail16.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1336663584.2581.9.camel@lorien2>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.3.228.113]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just cloned git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
last commit 0bed306

All 5 patches applied cleanly, maybe we are talking about different linux-next trees?


----- Original Message -----
> From: "Shuah Khan" <shuahkhan@gmail.com>
> To: "Igor Mammedov" <imammedo@redhat.com>
> Cc: shuahkhan@gmail.com, linux-kernel@vger.kernel.org, rob@landley.net, tglx@linutronix.de, mingo@redhat.com,
> hpa@zytor.com, x86@kernel.org, luto@mit.edu, "suresh b siddha" <suresh.b.siddha@intel.com>, avi@redhat.com, "a p
> zijlstra" <a.p.zijlstra@chello.nl>, johnstul@us.ibm.com, arjan@linux.intel.com, linux-doc@vger.kernel.org
> Sent: Thursday, May 10, 2012 5:26:24 PM
> Subject: Re: [PATCH 1/5] Fix soft-lookup in stop machine on secondary cpu bring up
> 
> 
> > > I could only guess that on bare metal SMI or other firmware issue
> > > may interfere with AP boot.
> > > Could you test if this patch-set fixes issue for you?
> > > And do you see the same problem during suspend/resume (assuming
> > > that it's booted without problem)?
> > > 
> > 
> > I had to abandon the boot and go back to distro installed kernel -
> > yes I
> > will test with your patch set and see if the problem goes away.
> > Might
> > not happen until close to end of day today, but will report back.
> 
> These patches failed to apply on linux-next May 9th. Couldn't get the
> testing done as planned.
> 
> -- Shuah
> 
> 
