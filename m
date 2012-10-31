Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935386Ab2JaKc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:32:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38179 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932889Ab2JaKcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:32:54 -0400
Date: Wed, 31 Oct 2012 11:32:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>, avi@redhat.com
Subject: Re: [PATCH 05/32] perf, kvm: Support the intx/intx_cp modifiers in KVM arch perfmon emulation v3
Message-ID: <20121031103248.GX16230@one.firstfloor.org>
References: <1351643663-23828-1-git-send-email-andi@firstfloor.org> <1351643663-23828-6-git-send-email-andi@firstfloor.org> <20121031102701.GB25650@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031102701.GB25650@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 12:27:01PM +0200, Gleb Natapov wrote:
> On Tue, Oct 30, 2012 at 05:33:56PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > This is not arch perfmon, but older CPUs will just ignore it. This makes
> > it possible to do at least some TSX measurements from a KVM guest
> > 
> You are ignoring my reviews.

Huh? I nearly rewrote the patch based on your feedback.
It's much more complicated now just for the CPUID check you wanted.
I hope all that code is worth it.

If you want more changes please let me know.

-Andi

