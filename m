Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab2FFKq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:46:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:33305 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab2FFKq1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:46:27 -0400
Message-ID: <1338979579.2749.95.camel@twins>
Subject: Re: [PATCH 5/5] perf, x86: Prefer RDPMC over RDMSR for reading
 counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Date: Wed, 06 Jun 2012 12:46:19 +0200
In-Reply-To: <1338944211-28275-5-git-send-email-andi@firstfloor.org>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
	 <1338944211-28275-5-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 17:56 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> RDPMC is much faster than RDMSR for reading performance counters,
> since it's not serializing.  Use it if possible in the perf handler.
> 
> Only tested on Sandy Bridge, so I only enabled it there so far.

That's just stupid.. I took Vince's patch from a while back.
