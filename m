Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab0KOKiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:38:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:8136 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab0KOKiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:38:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=wngihGhArJfsZSWC4wi46Zh9WHtH83Qdrt2wu5lj/elgLsxEyZm/D/gxtwqW/dPWVj
         u74lMBOCzIOLY065lRjQ==
Date: Mon, 15 Nov 2010 02:38:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] oom: document obsolete oom_adj tunable
In-Reply-To: <20101115091908.BEEB.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011150234530.2986@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1011091547030.30112@chino.kir.corp.google.com> <alpine.DEB.2.00.1011091555210.30112@chino.kir.corp.google.com> <20101115091908.BEEB.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, KOSAKI Motohiro wrote:

> > /proc/pid/oom_adj was deprecated in August 2010 with the introduction of
> > the new oom killer heuristic.
> > 
> > This patch copies the Documentation/feature-removal-schedule.txt entry
> > for this tunable to the Documentation/ABI/obsolete directory so nobody
> > misses it.
> > 
> > Reported-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> NAK. You seems to think shouting claim makes some effect. but It's incorrect.
> Your childish shout doesn't solve any real world issue. Only code fix does.
> 

The tunable is deprecated.  If you are really that concerned about the 
existing users who you don't think can convert in the next two years, why 
don't you help them convert?  That fixes the issue, but you're not 
interested in that.  I offered to convert any open-source users you can 
list (the hardest part of the conversion is finding who to send patches to 
:).  You're only interested in continuing to assert your position as 
correct even when the kernel is obviously moving in a different direction.

Others may have a different opinion of who is being childish in this whole 
ordeal.
