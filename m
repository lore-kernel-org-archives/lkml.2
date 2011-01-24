Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1AXRuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:50:08 -0500
Received: from claw.goop.org ([74.207.240.146]:42383 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab1AXRuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:50:06 -0500
Message-ID: <4D3DBBC6.1000407@goop.org>
Date: Mon, 24 Jan 2011 09:49:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: vatsa@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        kvm@vger.kernel.org, suzuki@in.ibm.com
Subject: Re: [PATCH 2/3] kvm hypervisor : Add hypercalls to support pv-ticketlock
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com> <20110119164432.GA30669@linux.vnet.ibm.com> <20110119171239.GB726@linux.vnet.ibm.com> <1295457672.28776.144.camel@laptop> <4D373340.60608@goop.org> <20110120115958.GB11177@linux.vnet.ibm.com> <4D38774B.6070704@goop.org> <20110121140208.GA13609@linux.vnet.ibm.com> <4D399CBD.10506@redhat.com> <20110122061417.GA7258@linux.vnet.ibm.com> <4D3AEF7A.1050709@redhat.com>
In-Reply-To: <4D3AEF7A.1050709@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2011 06:53 AM, Rik van Riel wrote:
> The main question that remains is whether the PV ticketlocks are
> a large enough improvement to also merge those.  I expect they
> will be, and we'll see so in the benchmark numbers.

The pathological worst-case of ticket locks in a virtual environment
isn't very hard to hit, so I expect they'll make a huge difference
there.   On lightly loaded systems (little or no CPU overcommit) then
they should be close to a no-op.

    J
