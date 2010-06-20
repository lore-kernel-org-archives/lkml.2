Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab0FTWvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:51:05 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49245 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab0FTWu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:50:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=DWflCqouL628DF3I7iM8TpImYBRimsLhklGddCuJbAr6HzWhPuf0FuYB5xKc3PjFPu
         fMx8WxxrpVYmovpo3bg+4Vzf3bT8VBuJvG/VhLPojBdV6L178tKYGLvj6EzTCzb8K1gF
         m05xT7187Bbvu0/E9RcKNSr074xrfskDYNR08=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.35-rc3: Reported regressions from 2.6.34
Date: Sun, 20 Jun 2010 18:50:54 -0400
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc3; KDE/4.3.5; x86_64; ; )
References: <lc60d4toGTL.A.QzD._LpHMB@chimera>
In-Reply-To: <lc60d4toGTL.A.QzD._LpHMB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006201850.54344.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 June 2010, Rafael J. Wysocki wrote:
>This message contains a list of some regressions from 2.6.34,
>for which there are no fixes in the mainline known to the tracking team.
>If any of them have been fixed already, please let us know.
>
>If you know of any other unresolved regressions from 2.6.34, please let us
>know either and we'll add them to the list.  Also, please let us know
>if any of the entries below are invalid.

I had submitted a bug/gotcha, two or 3 days back, but I don't see it in this 
list.  It showed a kernel BUG, unable to (mutter) at 0000000000004008 IIRC.

Found it. The Subject line of that msg was:
RE: 2.6.35-rc3 BUG: unable to handle kernel paging request at 
0000000000004008

Without the wordwrap of course.

It may, from the log captures I sent, have been triggered by amanda 
attempting to shut down a working tar instance that had timed out in the 
amanda view of how long it was taking.  I since added another 5 minutes to 
that timeout figure, and it has run just fine for 2 days now.  But it did 
cause the system to upchuck and had to be rebooted after as it caused klogd 
to exit similarly several minutes later.  Details are in the msg.

Off topic question:  Is there some way to get gmail to return ones posts?  
This posting to a black hole is getting frustrating.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Lieberman's Law:
	Everybody lies, but it doesn't matter since nobody listens.
