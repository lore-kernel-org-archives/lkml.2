Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab1LUWtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 17:49:05 -0500
Received: from 8bytes.org ([88.198.83.132]:53768 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab1LUWtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 17:49:03 -0500
Date: Wed, 21 Dec 2011 23:49:00 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111221224900.GD30127@8bytes.org>
References: <4EEF26F0.1050709@redhat.com> <20111220091511.GB3091@elte.hu> <4EF05996.8030807@redhat.com> <20111220100916.GA20788@elte.hu> <20111220152758.GA30127@8bytes.org> <20111220184004.GE8408@elte.hu> <20111221000716.GB30127@8bytes.org> <20111221123442.GB6071@elte.hu> <4EF1D4B6.3020408@redhat.com> <20111221132233.GB31186@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221132233.GB31186@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 02:22:33PM +0100, Ingo Molnar wrote:
> 
> * Avi Kivity <avi@redhat.com> wrote:
> > I hate to re-enter this thread, but this "niche use case" is 
> > exactly what LWP is designed for. [...]
> 
> It's not the only usecase that it can be used in, and that is 
> what matters to me.

The really sad thing about it is, that this only matters to you. At
least I have seen nobody in this thread yet who joined or agreed on your
line of reasoning. Especially sad is that your NAK based on this also
prevents that all the people who want to use LWP in the intended way on
Linux can't use it too.


	Joerg

