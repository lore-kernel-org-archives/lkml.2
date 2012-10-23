Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab2JWNf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:35:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59837 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab2JWNf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:35:27 -0400
Date: Tue, 23 Oct 2012 15:35:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>, avi@redhat.com,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 06/34] perf, kvm: Support the intx/intx_cp modifiers in KVM arch perfmon emulation v2
Message-ID: <20121023133527.GA16230@one.firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org> <1350602382-12771-7-git-send-email-andi@firstfloor.org> <1350995765.13456.15.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350995765.13456.15.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I forgot how all this worked, but will the KVM emulation not pass
> this straight down to the hardware?

Pass down to perf. 

> 
> Don't we have a problem where we're emulating arch perfmon v1 on AMD
> hardware? On AMD hardware those bits do have meaning.

Ah they do? I wasn't aware. I can add a cpuid check for Intel I suppose.

-andi

-- 
ak@linux.intel.com -- Speaking for myself only.
