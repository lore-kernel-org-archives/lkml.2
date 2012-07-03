Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290Ab2GCHg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 03:36:29 -0400
Received: from ozlabs.org ([203.10.76.45]:35106 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab2GCHg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 03:36:28 -0400
Message-ID: <1341300987.11663.15.camel@concordia>
Subject: Re: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw
 format
From: Michael Ellerman <michael@ellerman.id.au>
To: Feng Tang <feng.tang@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Date: Tue, 03 Jul 2012 17:36:27 +1000
In-Reply-To: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
References: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 00:00 +0800, Feng Tang wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add support for reporting PEBS records in a raw format that can
> be then parsed by perf script.
> 
> This is roughly similar to the existing AMD IBS support.
> 
> This is mainly for advanced users and to experiment with
> new usages. Widespread PEBS usages are expected to get higher
> level interfaces over time, like the existing "precise ip" support.

Hi folks,

Pardon if I slightly hijack this thread, but we'd like to do something
similar to this on powerpc.

I've been telling people not to use PERF_SAMPLE_RAW because it provides
no way for the consumer to know what data they're getting, and it's not
extensible in any way.

So is shovelling things out using PERF_SAMPLE_RAW generally acceptable
for "advanced usage" scenarios?

cheers



