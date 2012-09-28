Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363Ab2I1PYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:24:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:34594 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758025Ab2I1PYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:24:06 -0400
Message-ID: <1348845807.3292.88.camel@twins>
Subject: Re: [PATCH 04/31] perf, core: Add generic intx/intx_checkpointed
 counter modifiers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>
Date: Fri, 28 Sep 2012 17:23:27 +0200
In-Reply-To: <20120928145324.GQ16230@one.firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	 <1348806696-31170-5-git-send-email-andi@firstfloor.org>
	 <1348822920.3292.60.camel@twins>
	 <20120928145324.GQ16230@one.firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 16:53 +0200, Andi Kleen wrote:
> 
> Also as a selfish reason I would prefer something that is short 
> to type. The qualifiers are quite common in scripts that do
> measurements here. So I would prefer to keep :t and :c as user
> interface.  But the internal implementation can be adjusted 
> of course. 

But since its so very specific to HSW consuming such limited resources
as event attribute characters seems like a bad idea.

Maybe we can allow some configuration on the userspace side that would
allow each individual user to be lazy and create shortcuts or aliasses
of some sort ?
