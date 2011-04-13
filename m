Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab1DMAtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 20:49:12 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60940 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518Ab1DMAtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 20:49:10 -0400
Subject: Re: [PATCH resend^2] mm: increase RECLAIM_DISTANCE to 30
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Chris McDermott <lcm@linux.vnet.ibm.com>
In-Reply-To: <alpine.DEB.2.00.1104121719430.10966@chino.kir.corp.google.com>
References: <20110411172004.0361.A69D9226@jp.fujitsu.com>
	 <1302557371.7286.16607.camel@nimitz>
	 <alpine.DEB.2.00.1104121719430.10966@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 12 Apr 2011 17:49:06 -0700
Message-ID: <1302655746.8321.4001.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 17:22 -0700, David Rientjes wrote:
> On Mon, 11 Apr 2011, Dave Hansen wrote:
> I know specifically of pieces of x86 hardware that set the information
> > in the BIOS to '21' *specifically* so they'll get the zone_reclaim_mode
> > behavior which that implies.
> 
> That doesn't seem like an argument against this patch, it's an improper 
> configuration unless the remote memory access has a latency of 2.1x that 
> of a local access between those two nodes.  If that's the case, then it's 
> accurately following the ACPI spec and the VM has made its policy decision 
> to enable zone_reclaim_mode as a result.

Heh, if the kernel broke on every system that didn't follow _some_ spec,
it wouldn't boot in very many places.

When you have a hammer, everything looks like a nail.  When you're a
BIOS developer, you start thwacking at the kernel with munged ACPI
tables instead of boot options.  Folks do this in the real world, and I
think if we can't put their names and addresses next to the code that
works around this, we might as well put the DMI strings of their
hardware. :) 

-- Dave

