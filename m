Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab2JWNaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:30:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59813 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab2JWNaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:30:01 -0400
Date: Tue, 23 Oct 2012 15:30:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 05/34] perf, x86: Report PEBS event in a raw format
Message-ID: <20121023133000.GX16230@one.firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org> <1350602382-12771-6-git-send-email-andi@firstfloor.org> <1350995474.13456.12.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350995474.13456.12.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, there's an alignment issue there, the raw.data is 32bit offset,
> the record is u64 aligned, leaving the output stream offset, wrecking
> things.

Can you explain more? Not sure I understand.

It appears to work at least.

> 
> And as with any ABI extension, it should come with useful userspace to
> make use of it.

There are already scripts available to use it, see Feng's patchkit.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
