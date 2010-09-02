Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab0IBKDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 06:03:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43605 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab0IBKDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 06:03:13 -0400
Date: Thu, 2 Sep 2010 12:03:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] [arch-x86] Allow SRAT integrity check to be skipped
Message-ID: <20100902100308.GA17167@basil.fritz.box>
References: <20100901213318.19353.54619.stgit@localhost.localdomain>
 <20100902065731.GB29972@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902065731.GB29972@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This isnt a particularly useful solution to users of said systems - they 
> have to figure out that this option exists, and then they have to enter 
> this option on the boot line.

This usually only happens in early preproduction systems. So far
the BIOS always got fixed before they shipped to users.

But it's still useful to have this option so that the early
users have a workaround.

It's difficult to maintain DMI strings for early systems,
they are too bleeding edge and the entries would be stale
as soon as the BIOS is fixed.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
