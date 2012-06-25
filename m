Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab2FYJll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:41:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab2FYJlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:41:23 -0400
Message-ID: <4FE83235.2000406@redhat.com>
Date: Mon, 25 Jun 2012 12:41:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv9 0/8] kvm: eoi optimization support
References: <cover.1340554550.git.mst@robin.redhat.com>
In-Reply-To: <cover.1340554550.git.mst@robin.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2012 07:24 PM, Michael S. Tsirkin wrote:
> I'm looking at reducing the interrupt overhead for virtualized guests:
> some workloads spend a large part of their time processing interrupts.
> 
> On kvm, an EOI write from the guest causes an expensive exit to host; we
> avoid this using shared memory.
> 
> The patches work fine on my boxes. See individual patches
> for perf tests. You need to patch qemu to whitelist the kvm feature.
> qemu patch was sent separately.
> 
> The patches are against Linus's master and apply to kvm.git
> cleanly.  The last patch in the series, supplying the host
> part, also depends on the ISR optimization patch that I
> have for convenience included in the series (patch 2),
> I also included a documentation patch (patch 1) - it is
> here since it clarifies patch 2.  This revision does not yet address
> Thomas's idea of reworking the APIC page handling.  Changes to this
> optimization would require reworking this last patch in the series.
> 
> The rest of the patchset has not changed significantly since v2.

Thanks, applied.


-- 
error compiling committee.c: too many arguments to function


