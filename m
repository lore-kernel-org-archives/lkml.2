Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab2I1Ins (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:43:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:56603 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422Ab2I1Inq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:43:46 -0400
Message-ID: <1348821784.3292.50.camel@twins>
Subject: Re: [PATCH 01/31] perf, x86: Add PEBSv2 record support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Date: Fri, 28 Sep 2012 10:43:04 +0200
In-Reply-To: <1348806696-31170-2-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	 <1348806696-31170-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 21:31 -0700, Andi Kleen wrote:
> +               if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format < 2) {

Shouldn't that be: && x86_pmu.intel_cap.pebs_trap, like most other sites
instead? Or didn't they flip the trap capability on Haswell?
