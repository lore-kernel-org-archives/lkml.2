Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836Ab1FVUJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:09:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:28822 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758471Ab1FVUJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:09:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,407,1304319600"; 
   d="scan'208";a="19423355"
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc4
References: <BANLkTimiVpKavmKY=rsJP34dMQSq__Xn7g@mail.gmail.com>
Date: Wed, 22 Jun 2011 13:08:00 -0700
In-Reply-To: <BANLkTimiVpKavmKY=rsJP34dMQSq__Xn7g@mail.gmail.com> (Linus
	Torvalds's message of "Mon, 20 Jun 2011 21:02:56 -0700")
Message-ID: <m2boxp39zz.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> and the
> conversion from spinlocks to mutexes for the anon_vma locking ended up
> causing a scalability issue that required fixing.

FWIW it's still ~16% slower. Does that count as fixed?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
