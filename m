Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab2EAEiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 00:38:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:58017 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab2EAEiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 00:38:01 -0400
Message-ID: <1335845444.3621.11.camel@pasglop>
Subject: Re: [PATCH v3 03/17] powerpc: Add PFO support to the VIO bus
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        rcj@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <1335841603.3621.8.camel@pasglop>
References: <1334242825.18090.4.camel@key-ThinkPad-W510>
	 <1334243302.18090.10.camel@key-ThinkPad-W510>
	 <1335841603.3621.8.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 May 2012 14:10:44 +1000
Mime-Version: 1.0
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Else, what about ceding the processor ? Or at the very least reducing
> the thread priority for a bit ?
> 
> Shouldn't we also enforce to always have a timeout ? IE. Something like
> 30s or so if nothing specified to avoid having the kernel just hard
> lock...
> 
> In general I don't like that sort of synchronous code, I'd rather return
> the busy status up the chain which gives a chance to the caller to take
> more appropriate measures depending on what it's doing, but that really
> depends what you use that synchronous call for. I suppose if it's for
> configuration type operations, it's ok...

In any case, don't resend the whole series, just that one patch.

Cheers,
Ben.



