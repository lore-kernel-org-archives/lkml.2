Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab2F1QNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:13:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45323 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2F1QNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:13:06 -0400
Message-ID: <1340899974.28750.66.camel@twins>
Subject: Re: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw
 format
From: Peter Zijlstra <peterz@infradead.org>
To: Feng Tang <feng.tang@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Date: Thu, 28 Jun 2012 18:12:54 +0200
In-Reply-To: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
References: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
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
> 
> [Small fix of adding "data.raw = &raw;", thanks to Andi, with this
> patch I can test my perf script with pebs samples. - Feng]
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Feng Tang <feng.tang@intel.com> 

Not without a useful userspace part. Preferably not a script.
