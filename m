Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab1KURX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:23:27 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41431 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623Ab1KURX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:23:26 -0500
Date: Mon, 21 Nov 2011 17:23:24 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "mingo@elte.hu" <mingo@elte.hu>, William Cohen <wcohen@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Cree <mcree@orcon.net.nz>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Anton Blanchard <anton@samba.org>, Eric B Munson <emunson@mgebm.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Kuo <rkuo@codeaurora.org>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>
Subject: Re: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()
Message-ID: <20111121172323.GH20611@mudshark.cambridge.arm.com>
References: <20111121145114.049265181@chello.nl>
 <20111121145337.533322271@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121145337.533322271@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Nov 21, 2011 at 02:51:16PM +0000, Peter Zijlstra wrote:
> Put the logic to compute the event index into a per pmu method. This
> is required because the x86 rules are weird and wonderful and don't
> match the capabilities of the current scheme.
> 
> AFAIK only powerpc actually has a usable userspace read of the PMCs
> but I'm not at all sure anybody actually used that.
> 
> ARM looks like it cared, but I really wouldn't know, Will?

It used to care, but it doesn't anymore. Feel free to make the offset 0 and
use the (now) generic codepath.

With that:

Acked-by: Will Deacon <will.deacon@arm.com>

Will
