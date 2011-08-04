Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab1HDBfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 21:35:01 -0400
Received: from tundra.namei.org ([65.99.196.166]:39519 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004Ab1HDBe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 21:34:56 -0400
Date: Thu, 4 Aug 2011 11:34:10 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Leendert van Doorn <leendert@watson.ibm.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        tpmdd-devel@lists.sourceforge.net,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] tpm_tis: fix build when ACPI is not enabled
In-Reply-To: <20110803185634.GA16988@elte.hu>
Message-ID: <alpine.LRH.2.00.1108041133260.25037@tundra.namei.org>
References: <20110727141151.d31e3da6a8d21a255473293c@canb.auug.org.au> <20110727114211.18be47cf.rdunlap@xenotime.net> <20110803185634.GA16988@elte.hu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Aug 2011, Ingo Molnar wrote:

> This fix was sent 5+ days ago (with still no reply to it), a day 
> after this fix the security tree pull request was sent with this 
> known build breakage included, so the bug is still unfixed upstream 
> and no fix is in the pipeline AFAICS. Got lost?

I thought it was already fixed in another patch.

Andrew just sent it to Linus, so it should be upstream soon.


- James
-- 
James Morris
<jmorris@namei.org>
