Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0FCPNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 11:13:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36827 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab0FCPNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 11:13:52 -0400
Date: Thu, 3 Jun 2010 17:13:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Vivek Goyal <vgoyal@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 0/5] kdump: extract log buffer and registers from vmcore
	on NMI button pressing
Message-ID: <20100603151347.GC4166@basil.fritz.box>
References: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com> <20100602151611.GA3174@redhat.com> <87iq60a3rh.wl%vmayatsk@redhat.com> <87d3w8xy3q.fsf@basil.nowhere.org> <874ohkuwhs.wl%vmayatsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874ohkuwhs.wl%vmayatsk@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > NMI would be only needed if the crash kernel is completely
> > hosed too.
> 
> That's the case.

You're saying it booted but is hosed after boot?

That seems like a very obscure case. Is that really common?

> True. But as a last hope, when nothing else helps, it still may be
> worth trying :)

It will simply not work.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
