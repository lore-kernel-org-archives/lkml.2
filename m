Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab2I1IzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:55:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:56846 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066Ab2I1IzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:55:12 -0400
Message-ID: <1348822473.3292.55.camel@twins>
Subject: Re: [PATCH 08/31] perf, x86: Report PEBS event in a raw format
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Date: Fri, 28 Sep 2012 10:54:33 +0200
In-Reply-To: <1348806696-31170-9-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	 <1348806696-31170-9-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 21:31 -0700, Andi Kleen wrote:
> Left over are the general registers. We need them for some analysis
> too: for example for loop trip count and string instruction trip
> count sampling.
> 
> There isn't really any good way to generalize general registers.
> Obviously they are different for every architecture.

You missed the whole PERF_SAMPLE_REGS_USER stuff?
