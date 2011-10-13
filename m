Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1JMTGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 15:06:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39151 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab1JMTF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 15:05:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/3] Mutually exclude cpu online and suspend/hibernate
Date: Thu, 13 Oct 2011 21:08:20 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, bp@amd64.org, pavel@ucw.cz,
        len.brown@intel.com, mingo@elte.hu, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, lucas.demarchi@profusion.mobi,
        rusty@rustcorp.com.au, rdunlap@xenotime.net, vatsa@linux.vnet.ibm.com,
        ashok.raj@intel.com, tigran@aivazian.fsnet.co.uk, tglx@linutronix.de,
        hpa@zytor.com, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com> <4E9706D8.5040105@linux.vnet.ibm.com> <20111013160602.GJ6281@google.com>
In-Reply-To: <20111013160602.GJ6281@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110132108.21201.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 13, 2011, Tejun Heo wrote:
> Hello,
> 
> On Thu, Oct 13, 2011 at 09:12:16PM +0530, Srivatsa S. Bhat wrote:
> > Given that the microcode update hotplug optimization is going upstream,
> > (https://lkml.org/lkml/2011/10/13/258), we know that whether we want to call
> > it a bugfix or optimization, either way it *is* going to fix this bug.
> > And this current patchset's mutual exclusion approach was also aimed at fixing
> > the same bug since at the time it was written, discussion was still going on
> > about which solution would be better.
> 
> I hate to sound like a broken recorder but the above patch isn't
> strictly correct for hot-swap cases, right?  Let's please add
> revalidation before pushing that upstream.  Rafael, did you already
> take that patch?

No, I didn't, but I'm not sure about the x86 maintainers.

Thanks,
Rafael
