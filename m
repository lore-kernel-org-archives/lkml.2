Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab1ADKc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 05:32:28 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:58694 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750954Ab1ADKc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 05:32:27 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18f9c9kLM8fFclArvyUMqcZ7+wVHw7VpKvfCjkGeQ
	iwgO3ZmAFuwwT2
Subject: Re: [RFC -v3 PATCH 0/3] directed yield for Pause Loop Exiting
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D22E3C0.7010808@redhat.com>
References: <20110103162637.29f23c40@annuminas.surriel.com>
	 <1294123335.11283.26.camel@marge.simson.net>  <4D22E3C0.7010808@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 11:32:14 +0100
Message-ID: <1294137134.4379.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 11:09 +0200, Avi Kivity wrote:
> On 01/04/2011 08:42 AM, Mike Galbraith wrote:

> > If I were to, say, run a 256 CPU VM on my quad, would this help me get
> > more hackbench or whatever oomph from my (256X80386/20:) box?
> 
> First of all, you can't run 256 guests on x86 kvm.

I didn't want 256 guests. Just one great big dog slow virtual playpen :)

> > >  Both Intel and AMD CPUs have a feature that detects when a virtual
> > >  CPU is spinning on a lock and will trap to the host.
> >
> > Does an Intel Q6600 have this trap gizmo (iow will this do anything at
> > all for my little box if I were to try it out).
> 
> Likely not.  Run 
> http://git.kernel.org/?p=virt/kvm/qemu-kvm.git;a=blob_plain;f=kvm/scripts/vmxcap;hb=HEAD, 
> look for 'PAUSE-loop exiting'.  I think the first processors to include 
> them were the Nehalem-EXs, and Westmeres have them as well.

Oh darn, need new box to get all the toys.  Thanks.

	-Mike


