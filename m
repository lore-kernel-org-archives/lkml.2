Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab0HTNN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 09:13:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724Ab0HTNNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 09:13:55 -0400
Subject: Re: struct fanotify_event_metadata
From: Eric Paris <eparis@redhat.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Andreas Gruenbacher <agruen@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <m3pqxd7ift.fsf@hase.home>
References: <m21va1ozqx.fsf@igel.home>
	 <201008191644.29299.tvrtko.ursulin@sophos.com>
	 <1282240426.21419.1716.camel@acb20005.ipt.aol.com>
	 <201008201002.16235.tvrtko.ursulin@sophos.com>  <m3pqxd7ift.fsf@hase.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 09:13:36 -0400
Message-ID: <1282310016.21419.2161.camel@acb20005.ipt.aol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 11:16 +0200, Andreas Schwab wrote:
> Tvrtko Ursulin <tvrtko.ursulin@sophos.com> writes:
> 
> > Shrink pid field in the fanotify_event_metadata to 32-bit to match
> > the kernel representation. Pull mask field up since it logically
> > comes before event auxiliary data and also makes for a nicer
> > alignment.
> 
> That won't buy you much wrt. alignment though, due to the packed
> attribute.

Can you help me understand the packed attribute and why it hurts in this
case?  It's not going to change the alignment or placement of anything
and I saw it as just being needed to make sure everything would continue
to work in the future.

I'm going to compile a couple of test programs (I only have x86 and
x86_64) to see if I can find what the assembly is doing different but
maybe you can point me at the information more easily?

-Eric


