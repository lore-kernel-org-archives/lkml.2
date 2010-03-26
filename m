Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0CZOnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 10:43:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42645 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab0CZOns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 10:43:48 -0400
Subject: Re: [PATCH] perf, x86: Add Nehelem PMU programming errata
 workaround
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Stephane Eranian <eranian@google.com>
In-Reply-To: <1269608924.12097.147.camel@laptop>
References: <1269608924.12097.147.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 15:43:44 +0100
Message-ID: <1269614624.12097.149.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 14:08 +0100, Peter Zijlstra wrote:
> Subject: perf, x86: Add Nehelem PMU programming errata workaround
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri Mar 26 13:59:41 CET 2010
> 
> Implement the workaround for Intel Errata AAK100 and AAP53.
> 
> Also, remove the Core-i7 name for Nehalem events since there are also
> Westmere based i7 chips.

*sigh* it appears the westmere chips suffer this too according to the
new Xeon 5600 docs (BD53) .. I'll update the patch.


