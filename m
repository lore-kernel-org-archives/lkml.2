Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab0KIXsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:48:25 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17496 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab0KIXsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:48:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=qzo1jHS4x2aofK5vZLnB7Y0vv15VazAns4tAtgfaprfvicVXNUnJLCMQm3O7BITiik
         uHoyUgIviY8QD6w1l6Ww==
Date: Tue, 9 Nov 2010 15:48:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH 2/4] Revert "oom: deprecate oom_adj tunable"
In-Reply-To: <20101109233541.13be4cd5@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.00.1011091547030.30112@chino.kir.corp.google.com>
References: <20101101030353.607A.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011011232120.6822@chino.kir.corp.google.com> <20101109105801.BC30.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011091523370.26837@chino.kir.corp.google.com>
 <20101109233541.13be4cd5@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, Alan Cox wrote:

> > It's deprecated for a few years so users can gradually convert to the new 
> > tunable, it wasn't removed when the new one was introduced.  A higher 
> > resolution tunable that scales linearly with a unit is an advantage for 
> > Linux (for the minority of users who care about oom killing priority 
> > beyond the heuristic) and I think a few years is enough time for users to 
> > do a simple conversion to the new tunable.
> 
> Documentation/ABI/obsolete/
> 
> should have all obsoletes in it.
> 

Good point, the only documentation right now is in 
Documentation/feature-removal-schedule.txt and in the kernel log the first 
time oom_adj is written.  I'll generate a patch, thanks!
