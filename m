Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab2JXHuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 03:50:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41057 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab2JXHuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 03:50:15 -0400
Date: Wed, 24 Oct 2012 09:50:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 05/34] perf, x86: Report PEBS event in a raw format
Message-ID: <20121024075010.GC25872@gmail.com>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
 <1350602382-12771-6-git-send-email-andi@firstfloor.org>
 <1350995474.13456.12.camel@twins>
 <20121023133000.GX16230@one.firstfloor.org>
 <1351000250.13456.34.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351000250.13456.34.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> I never can seem to figure out how to use the scripts mess :/ 
> acme, is there anything we could do to make that stuff usable? 
> There's a ton of crap under scripts/ but I don't even know how 
> to get that stuff to run.
> 
> What's more, all that nonsense is in weird languages I don't 
> do either, making it less useful than usual.
> 
> In short, I don't consider script/ to be proper userspace 
> since its bloody useless.

We should not queue new kernel bits up until there's meaningful, 
well working user-space support for it in the primary tools.

Thanks,

	Ingo
