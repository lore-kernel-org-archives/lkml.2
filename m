Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab2EDU2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:28:01 -0400
Received: from mk-filter-1-a-2.mail.tiscali.co.uk ([212.74.100.48]:54507 "EHLO
	mk-filter-1-a-2.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868Ab2EDU17 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:27:59 -0400
X-Greylist: delayed 647 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2012 16:27:59 EDT
X-Trace: 769075127/mk-filter-1.mail.uk.tiscali.com/WEBB2C/$webb2c-ALLOWED_RELAY/webb2c-ALLOWED-B2C-WEBMAIL/62.24.139.126/None/dilieto@lineone.net
X-SBRS: None
X-RemoteIP: 62.24.139.126
X-IP-MAIL-FROM: dilieto@lineone.net
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUEAOk4pE8+GIt+/2dsb2JhbABFhW6pTYQ3ggkBAQQkVgUWGAICDRkCgQ2HbQmoP5JwgS+MOYINgRgEpkCCaQ
X-IronPort-AV: E=Sophos;i="4.75,533,1330905600"; 
   d="scan'208";a="769075127"
Message-ID: <32467848.260261336162622524.JavaMail.defaultUser@defaultHost>
Date: Fri, 4 May 2012 21:17:02 +0100 (BST)
From: "dilieto@lineone.net" <dilieto@lineone.net>
To: Knut_Petersen@t-online.de
Subject: Re: [REGRESSION][PATCH] Fix an old sky2 WOL regression
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>, arekm@maven.pl,
        Jared <nitro@legroom.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Knut,

I am sorry it took a while to try it due to other 
commitments, however I can now confirm the patch works on my ASUS P5LD2 
motherboard.

Many thanks
Nicola

On 2012-03-21 12:40, Knut Petersen 
wrote:
> Sky2 Wake on LAN is broken since February 2010 on a number of 
systems.
> Yes. More than two years.
>
> We know about the problem and 
the cause since October 2010
> (Bugzilla bug #19492). It´s commit 
87b09f1f25cd1e01d7c50bf423c7fe33027d7511.
>
> Stephen, David: You 
signed off that commit.
>
> Andrew: You called it a regression in 
October 2010.
>
> It has been proposed to revert the commit that caused 
the problem.
> Nothing happened.
>
> I proposed to re-establish the old 
code for dmi_match()ed systems.
> Without success.
>
> Now it is 
proposed to re-establish the old code as a configuration option.
> If 
nothing happens again I will propose a module parameter ;-)
>
> 
Stephen, I don´t want to be a pain in the neck, and it is not my 
intention
> to offend you by my "attitude". But I simply cannot 
understand why this
> know regression is not fixed. The bit we talk 
about is documented,
> and in fact it was set for a number of kernel 
versions unconditionally.
> Nobody complained about ruined hardware or 
minor problems.
>
> The systems affected are old enough that no 
manufacturer cares about
> them, but they are still quite usable for a 
lot of jobs (kernel 3.3 compile
> time here is below 15 minutes).
>
> 
If there is a problem in the kernel and if we do know an easy solution,

> that solution should be commited to the kernel, no matter what is 
written
> in some random documentation, no matter if we could blame 
some
> BIOS authors. That´s the way Linux works - at least I thought 
so.
>
> cu,
> Knut
