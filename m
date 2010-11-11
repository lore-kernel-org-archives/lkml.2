Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab0KKT7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:59:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:38430 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab0KKT7n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:59:43 -0500
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw
 events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com, eranian@google.com
In-Reply-To: <20101111194936.GJ18718@basil.fritz.box>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
	 <1289492117-18066-2-git-send-email-andi@firstfloor.org>
	 <4CDC2DDD.50508@linux.vnet.ibm.com> <4CDC3845.4030104@linux.intel.com>
	 <4CDC4628.8020109@linux.vnet.ibm.com>
	 <20101111194936.GJ18718@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 20:59:47 +0100
Message-ID: <1289505587.2084.193.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 20:49 +0100, Andi Kleen wrote:
> > I think it would have parsed OK, but it is a confusing syntax to
> > look at.  I should point out that there are also the u,k,h modifiers
> > which can be specified, even on raw events, so the full syntax looks
> > something like:
> > 
> > -e rXXXX[+YYYY][:u|:k|:h]
> 
> Ok I can fix the help text for that.

If we're frobbing it in the existing config qword, do we still need
special syntax?

Also, I think we can use the same mechanism to program the
PEBS-load-latency MSR, right?
