Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab0KPI0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 03:26:18 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:20948 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752999Ab0KPI0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 03:26:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAELN4Ux5Ldur/2dsb2JhbACiWnK+WIVLBA
Date: Tue, 16 Nov 2010 19:26:12 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] mm: vmscan implement per-zone shrinkers
Message-ID: <20101116082612.GA3709@amd>
References: <20101109123246.GA11477@amd>
 <20101114182614.BEE5.A69D9226@jp.fujitsu.com>
 <20101115092452.BEF1.A69D9226@jp.fujitsu.com>
 <20101116074717.GB3460@amd>
 <AANLkTi=BhuVn8F3ioTyR8S=J3LfJbuhYsMoHf9f=bvRn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=BhuVn8F3ioTyR8S=J3LfJbuhYsMoHf9f=bvRn@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 09:53:19AM +0200, Anca Emanuel wrote:
> Nick, I want to test your tree.
> This is taking too long.
> Make something available now. And test it in real configs.

I'm working on it, I'll have another batch of patches out to look at
in a couple of hours, if stress testing holds up.
