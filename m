Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab2I1Jg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:36:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:57434 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab2I1Jg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:36:28 -0400
Message-ID: <1348824980.3292.68.camel@twins>
Subject: Re: [PATCH 26/31] perf, x86: Support for printing PMU state on
 spurious PMIs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Date: Fri, 28 Sep 2012 11:36:20 +0200
In-Reply-To: <1348806696-31170-27-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	 <1348806696-31170-27-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 21:31 -0700, Andi Kleen wrote:

> +static bool print_spurious_pmi __read_mostly;
> +module_param(print_spurious_pmi, bool, 0644);

Shouldn't this be a per-pmu sysfs attr? 
