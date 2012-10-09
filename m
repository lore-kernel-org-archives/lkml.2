Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab2JIS3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:29:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14329 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2JIS27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:28:59 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=F0my4ousGMIA:10 a=VwQbUJbxAAAA:8 a=VsGcPnjb5Y4tuNWwF04A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349807338.24256.37.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.6.1-rt1
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Tue, 09 Oct 2012 14:28:58 -0400
In-Reply-To: <1349806792.24256.34.camel@gandalf.local.home>
References: <alpine.LFD.2.02.1210091535140.10988@ionos>
	 <1349806792.24256.34.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 14:19 -0400, Steven Rostedt wrote:
> On Tue, 2012-10-09 at 15:46 +0200, Thomas Gleixner wrote:
> > Dear RT Folks,
> > 
> > I'm pleased to announce the 3.6.1-rt1 release.
> > 
> > This is a pretty straight forward move from the 3.4-rt series which
> > includes a few significant updates which need to be backported to the
> > 3.x-rt stable series:
> 
> My scripts detected these patches to be pulled into stable. It detects
> any patch that has a Cc: to stable-rt@vger.kernel.org that does not
> already exist in stable. It also adds the '000x-' prefix to keep the
> order.
> 
> 0000-scsi-qla2xxx-fix-bug-sleeping-function-called-from-invalid-context.patch
> 0001-upstream-net-rt-remove-preemption-disabling-in-netif_rx.patch

The above seem to be already applied (at least to 3.4-rt). Not sure why
my scripts missed it. Perhaps these were the ones added directly, and
the names of the patch that I used did not match your names. My script
saves off what it already applied, to know what it can skip for later
pulls.

-- Steve

> 0002-random-make-it-work-on-rt.patch
> 0003-softirq-init-softirq-local-lock-after-per-cpu-section-is-set-up.patch
> 0004-mm-slab-fix-potential-deadlock.patch
> 0005-mm-page-alloc-use-local-lock-on-target-cpu.patch
> 0006-rt-rw-lockdep-annotations.patch
> 0007-stomp-machine-deal-clever-with-stopper-lock.patch
> 


