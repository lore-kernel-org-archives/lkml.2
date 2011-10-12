Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab1JLHqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 03:46:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34533 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab1JLHqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 03:46:20 -0400
Subject: Re: [PATCH RFC V3 2/8] stop_machine: make stop_machine safe and
 efficient to call early
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Wed, 12 Oct 2011 09:45:48 +0200
In-Reply-To: <20111012073402.GJ18618@elte.hu>
References: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
	 <619c66d6da63aa086e2eac017e7aed216cc8ddc3.1317755691.git.jeremy.fitzhardinge@citrix.com>
	 <8762k4grwy.fsf@rustcorp.com.au> <20111010073405.GC29035@elte.hu>
	 <4E934F37.2020300@goop.org> <20111012073402.GJ18618@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318405548.3968.7.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-12 at 09:34 +0200, Ingo Molnar wrote:
> 
> If it has Jason's and PeterZ's ack then it can go via any other tree 
> in this cycle - we are not carrying jump label patches right now.

I don't seem to have them in my inbox, just one or two patches of a
larger series.


