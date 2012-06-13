Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2FMPco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:32:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:34927 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2FMPcn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:32:43 -0400
Message-ID: <1339601552.8980.47.camel@twins>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, "Yu, Fenghua" <fenghua.yu@intel.com>
Date: Wed, 13 Jun 2012 17:32:32 +0200
In-Reply-To: <4FD89CD3.8050005@zytor.com>
References: <20120607071531.GA4849@quad> <4FD78BE6.4060207@zytor.com>
	  <20120612190720.GA11137@aftab.osrc.amd.com>
	  <1339529614.31548.104.camel@twins>
	  <20120612194900.GC11137@aftab.osrc.amd.com>
	 <1339576348.31548.114.camel@twins> <4FD89CD3.8050005@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 06:59 -0700, H. Peter Anvin wrote:
> On 06/13/2012 01:32 AM, Peter Zijlstra wrote:
> > On Tue, 2012-06-12 at 21:49 +0200, Borislav Petkov wrote:
> >>
> >> But why, do you see a better option for how to tell the kernel to load a
> >> binary blob early at boot? 
> > 
> > built it in? There's this feature where you can included firmware blobs
> > in the kernel image. It has all the benefits of initrd, since the only
> > time I ever would update initrd if used it, would be when I install a
> > new kernel, which I just built anyway.
> > 
> 
> You know you can build in an initramfs blob in the kernel, right?  In
> fact, there always is one there even if you don't create it explicitly.

Didn't know that..

> Problem solved, methinks.

Yep.
