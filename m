Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab2JEUCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 16:02:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45559 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab2JEUCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 16:02:51 -0400
Date: Fri, 5 Oct 2012 22:02:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, konrad.wilk@oracle.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        akpm@linux-foundation.org, joerg.roedel@amd.com, bhelgaas@google.com,
        shuahkhan@gmail.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, x86@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 0/7] Improve swiotlb performance by using physical addresses
Message-ID: <20121005200245.GQ16230@one.firstfloor.org>
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com> <m28vbkx3hw.fsf@firstfloor.org> <506F3670.4020202@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506F3670.4020202@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I was thinking the issue was all of the calls to relatively small
> functions occurring in quick succession.  The way most of this code is
> setup it seems like it is one small function call in turn calling
> another, and then another, and I would imagine the code fragmentation
> can have a significant negative impact.

Maybe. Can you just inline everything and see if it it's faster then?

This was out of line when the "text cost at all costs" drive was still
envogue, but luckily we're not doing  that anymore.

-Andiu

-- 
ak@linux.intel.com -- Speaking for myself only.
