Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066Ab2EJP03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:26:29 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:39345 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759132Ab2EJP01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:26:27 -0400
Message-ID: <1336663584.2581.9.camel@lorien2>
Subject: Re: [PATCH 1/5] Fix soft-lookup in stop machine on secondary cpu
 bring up
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Igor Mammedov <imammedo@redhat.com>
Cc: shuahkhan@gmail.com, linux-kernel@vger.kernel.org, rob@landley.net,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        luto@mit.edu, suresh.b.siddha@intel.com, avi@redhat.com,
        a.p.zijlstra@chello.nl, johnstul@us.ibm.com, arjan@linux.intel.com,
        linux-doc@vger.kernel.org
Date: Thu, 10 May 2012 09:26:24 -0600
In-Reply-To: <1336577648.2498.9.camel@lorien2>
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
	 <1336559102-28103-2-git-send-email-imammedo@redhat.com>
	 <1336575858.2498.7.camel@lorien2> <4FAA8BCC.5000704@redhat.com>
	 <1336577648.2498.9.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > I could only guess that on bare metal SMI or other firmware issue may interfere with AP boot.
> > Could you test if this patch-set fixes issue for you?
> > And do you see the same problem during suspend/resume (assuming that it's booted without problem)?
> > 
> 
> I had to abandon the boot and go back to distro installed kernel - yes I
> will test with your patch set and see if the problem goes away. Might
> not happen until close to end of day today, but will report back.

These patches failed to apply on linux-next May 9th. Couldn't get the
testing done as planned.

-- Shuah

