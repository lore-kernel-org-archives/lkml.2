Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab0KKUht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:37:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:47518 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab0KKUhs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:37:48 -0500
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw
 events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com, eranian@google.com
In-Reply-To: <20101111201259.GL18718@basil.fritz.box>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
	 <1289492117-18066-2-git-send-email-andi@firstfloor.org>
	 <4CDC2DDD.50508@linux.vnet.ibm.com> <4CDC3845.4030104@linux.intel.com>
	 <4CDC4628.8020109@linux.vnet.ibm.com>
	 <20101111194936.GJ18718@basil.fritz.box> <1289505587.2084.193.camel@laptop>
	 <20101111201259.GL18718@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 21:37:38 +0100
Message-ID: <1289507858.2084.195.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 21:12 +0100, Andi Kleen wrote:
> > Also, I think we can use the same mechanism to program the
> > PEBS-load-latency MSR, right?
> 
> I haven't looked at that, but if it's a per core resource
> the infrastructure can be reused at least. 

Can't remember if the load-latency msr is per-core, but its an extra reg
that needs to be set.

The nhm/wsm LBR config msr is per-core though, so that could use your
infrastructure too.
