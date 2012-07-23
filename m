Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab2GWRt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:49:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:15543 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158Ab2GWRt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:49:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="170271320"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: eranian@google.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: Sandy Bridge pebs fix fixes
References: <1342227494-24830-1-git-send-email-andi@firstfloor.org>
Date: Mon, 23 Jul 2012 10:49:25 -0700
In-Reply-To: <1342227494-24830-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Fri, 13 Jul 2012 17:58:12 -0700")
Message-ID: <m2eho24bbu.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> - Fix Peter's rewrite of the pebs microcode patches to actually work
> - Readd the early microcode update for onlined CPUs to close
> the "early schedule user space" race that Peter pointed out originally.

Ping!  This is still broken in tip/master.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
