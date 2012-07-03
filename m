Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab2GCJPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:15:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56017 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab2GCJPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:15:23 -0400
Message-ID: <1341306905.23484.53.camel@twins>
Subject: Re: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw
 format
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Feng Tang <feng.tang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Tue, 03 Jul 2012 11:15:05 +0200
In-Reply-To: <1341300987.11663.15.camel@concordia>
References: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
	 <1341300987.11663.15.camel@concordia>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 17:36 +1000, Michael Ellerman wrote:
> On Fri, 2012-06-29 at 00:00 +0800, Feng Tang wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Add support for reporting PEBS records in a raw format that can
> > be then parsed by perf script.
> > 
> > This is roughly similar to the existing AMD IBS support.
> > 
> > This is mainly for advanced users and to experiment with
> > new usages. Widespread PEBS usages are expected to get higher
> > level interfaces over time, like the existing "precise ip" support.
> 
> Hi folks,
> 
> Pardon if I slightly hijack this thread, but we'd like to do something
> similar to this on powerpc.

Do expand. What does exact information does it provide?

> I've been telling people not to use PERF_SAMPLE_RAW because it provides
> no way for the consumer to know what data they're getting, and it's not
> extensible in any way.
> 
> So is shovelling things out using PERF_SAMPLE_RAW generally acceptable
> for "advanced usage" scenarios?

No.
