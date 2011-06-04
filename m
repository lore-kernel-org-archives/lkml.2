Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab1FDUSq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 16:18:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:3897 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab1FDUSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 16:18:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,320,1304319600"; 
   d="scan'208";a="9084933"
From: Andi Kleen <andi@firstfloor.org>
To: "George Spelvin" <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to measure enable_kernel_fpu overhead?
References: <20110603172652.11807.qmail@science.horizon.com>
Date: Sat, 04 Jun 2011 13:17:43 -0700
In-Reply-To: <20110603172652.11807.qmail@science.horizon.com> (George
	Spelvin's message of "3 Jun 2011 13:26:52 -0400")
Message-ID: <m2pqmts654.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"George Spelvin" <linux@horizon.com> writes:
>
> Does anyone have any suggestions?

This seems to clever for its own good. Even if you come up with some
number on one CPU it could be completely different on another.
I would suggest KISS.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
