Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab0KWHRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:17:13 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37372 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab0KWHRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:17:01 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch] oom: document obsolete oom_adj tunable
Cc: kosaki.motohiro@jp.fujitsu.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1011150234530.2986@chino.kir.corp.google.com>
References: <20101115091908.BEEB.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011150234530.2986@chino.kir.corp.google.com>
Message-Id: <20101123161210.7BA8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Nov 2010 16:16:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 15 Nov 2010, KOSAKI Motohiro wrote:
> 
> > > /proc/pid/oom_adj was deprecated in August 2010 with the introduction of
> > > the new oom killer heuristic.
> > > 
> > > This patch copies the Documentation/feature-removal-schedule.txt entry
> > > for this tunable to the Documentation/ABI/obsolete directory so nobody
> > > misses it.
> > > 
> > > Reported-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > > Signed-off-by: David Rientjes <rientjes@google.com>
> > 
> > NAK. You seems to think shouting claim makes some effect. but It's incorrect.
> > Your childish shout doesn't solve any real world issue. Only code fix does.
> > 
> 
> The tunable is deprecated.  If you are really that concerned about the 
> existing users who you don't think can convert in the next two years, why 
> don't you help them convert?  That fixes the issue, but you're not 
> interested in that.  I offered to convert any open-source users you can 
> list (the hardest part of the conversion is finding who to send patches to 
> :).  You're only interested in continuing to assert your position as 
> correct even when the kernel is obviously moving in a different direction.

Why don't you change by _your_ hand? 

_Usually_ userland software changed at first _by_ who wanted the change.
Example, we fujitsu changed elf core file format when vma are >65536, but
It was not made any breakage. we changed gdb, binutils, elfutils and etc etc
_at_ first.




> 
> Others may have a different opinion of who is being childish in this whole 
> ordeal.



