Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab0G1XWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 19:22:53 -0400
Received: from xenotime.net ([72.52.115.56]:53885 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752171Ab0G1XWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 19:22:50 -0400
Date: Wed, 28 Jul 2010 16:22:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: David VomLehn <dvomlehn@cisco.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kernel GPLv question-"Prominent Notice"
Message-Id: <20100728162246.33f1a937.rdunlap@xenotime.net>
In-Reply-To: <20100728231017.GA23605@dvomlehn-lnx2.corp.sa.net>
References: <20100728231017.GA23605@dvomlehn-lnx2.corp.sa.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 16:10:17 -0700 David VomLehn wrote:

> Not looking to be flamed, but I gotta ask. The GPLv2 has the sentence:
> 
> 	You must cause the modified files to carry prominent notices
> 	stating that you changed the files and the date of any change.
> 
> My understanding of kernel community protocol is that you only put change
> info in the source file if you made a major change, not if you corrected
> something minor. IIRC, I even saw a patch bounced, in part, because it had
> a line of change info added for a minor fix. (Again, IIRC, it was accepted
> when it was resubmitted as modified)
> 
> We've been sued a time or two, making our legal folk a bit sensitive and
> they want developers to follow the GPL to the letter. Now, they're not
> likely to post anything here, but I thought I might personally get some
> sense of what the future might hold. And I'm confident I can look
> forward to some clearly stated viewpoints.
> -- 
> David VL
> --

Yeah, we aren't lawyers here (or the ones who are here usually
don't post anything -- they are read-only).  That makes these comments
worth what you paid for them.


a.  Changelogs go into the (git) patch description, not in the source code.

b.  Even if/when we put change comments in the source code, it's (usually) not
done for trivial changes.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
