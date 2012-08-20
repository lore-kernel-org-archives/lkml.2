Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2HTLSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:18:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:36743 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab2HTLSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:18:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,796,1336374000"; 
   d="scan'208";a="206340043"
Date: Mon, 20 Aug 2012 04:18:38 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        akpm@linux-foundation.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 46/74] x86, lto: Disable fancy hweight optimizations for
 LTO
Message-ID: <20120820111838.GC4461@tassilo.jf.intel.com>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
 <1345345030-22211-47-git-send-email-andi@firstfloor.org>
 <5030B1A5020000780008A200@nat28.tlf.novell.com>
 <20120819151516.GS11413@one.firstfloor.org>
 <50323427020000780009660E@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50323427020000780009660E@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's not the point: The point really is that you could allow the
> alternative regardless of LTO, and just penalize the LTO case
> by having even the asm clobber the registers that a function call
> would not preserve.

That's just what a normal call does, right?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
