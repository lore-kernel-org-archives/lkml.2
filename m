Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab1JMQGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:06:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36461 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab1JMQGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:06:08 -0400
Date: Thu, 13 Oct 2011 09:06:02 -0700
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        bp@amd64.org, pavel@ucw.cz, len.brown@intel.com, mingo@elte.hu,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        rdunlap@xenotime.net, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        tigran@aivazian.fsnet.co.uk, tglx@linutronix.de, hpa@zytor.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/3] Mutually exclude cpu online and
 suspend/hibernate
Message-ID: <20111013160602.GJ6281@google.com>
References: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com>
 <201110122131.08811.rjw@sisk.pl>
 <4E9605C7.5070203@linux.vnet.ibm.com>
 <201110130009.26552.rjw@sisk.pl>
 <4E9706D8.5040105@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9706D8.5040105@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 13, 2011 at 09:12:16PM +0530, Srivatsa S. Bhat wrote:
> Given that the microcode update hotplug optimization is going upstream,
> (https://lkml.org/lkml/2011/10/13/258), we know that whether we want to call
> it a bugfix or optimization, either way it *is* going to fix this bug.
> And this current patchset's mutual exclusion approach was also aimed at fixing
> the same bug since at the time it was written, discussion was still going on
> about which solution would be better.

I hate to sound like a broken recorder but the above patch isn't
strictly correct for hot-swap cases, right?  Let's please add
revalidation before pushing that upstream.  Rafael, did you already
take that patch?

Thanks.

-- 
tejun
