Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab0DNGyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:54:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:56953 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab0DNGyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:54:38 -0400
Subject: Re: [PATCH] powerpc/perf_event: Fix oops due to
 perf_event_do_pending call
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Anton Blanchard <anton@samba.org>
In-Reply-To: <20100414064603.GA4714@drongo>
References: <20100414064603.GA4714@drongo>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 16:53:16 +1000
Message-ID: <1271227996.13059.138.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 16:46 +1000, Paul Mackerras wrote:
> Ben, please put this in your tree of fixes to go to Linus for 2.6.34,
> since it fixes a potential panic.

Should it go to -stable as well ? How far back ?

Cheers,
Ben.

