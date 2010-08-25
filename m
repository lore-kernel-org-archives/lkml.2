Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0HYJUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:20:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:56208 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab0HYJUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:20:11 -0400
Subject: Re: [PATCH 0/3] Generalise ARM perf-events backend for oprofile
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1282727242.5727.7.camel@e102144-lin.cambridge.arm.com>
References: <1282560381-7700-1-git-send-email-matt@console-pimps.org>
	 <20100823105759.GA18638@infradead.org> <1282700516.22370.567.camel@pasglop>
	 <1282727242.5727.7.camel@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 19:19:01 +1000
Message-ID: <1282727941.22370.606.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 10:07 +0100, Will Deacon wrote:
> Ideally, the OProfile userspace tools would talk native perf and we
> could do away with oprofilefs and the oprofile buffer altogether.
> Compatibility with the old [read current] OProfile tools can be
> maintained using these patches until the API is deprecated.
> 
> Or is that a bit too optimistic? :) 

Heh, well, dunno, I suspect just moving userspace to native perf tools
is going to happen as soon is not sooner :-)

Ben.

