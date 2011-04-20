Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1DTUdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:33:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39622 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab1DTUdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:33:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@tikei.de>
Subject: Re: [linux-pm] /proc/acpi/wakeup regression in 2.6.39-rc3
Date: Wed, 20 Apr 2011 22:34:12 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <201104150053.37037.rjw@sisk.pl> <20110419202212.GA15438@mac.home> <201104192328.52652.rjw@sisk.pl>
In-Reply-To: <201104192328.52652.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104202234.12742.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 19, 2011, Rafael J. Wysocki wrote:
> On Tuesday, April 19, 2011, Tino Keitel wrote:
> > Hi,
> > 
> > I reverted some wakeup and ACPI related commits. When I reverted commit
> > 7fa69baf29de8c77a6b32c054df2abb8f11f8aa4, wakeup using the keyboard
> > worked again and /proc/acpi/wakeup behaved as expected.
> 
> Oh, I doubt that this particular one is the problem.
> 
> > So check this, I reverted the following commits to avoid conflicts and
> > build failures:
> > 
> > c19f9a84ec807da57fd75bbd9a3f2b8269611f79
> > 5190726765b40774c069e187a958e10ccd970e65
> > 2a5d24286e8bdafdc272b37ec5bdd9e977b3767c
> > f2b56bc808addb908a5bf435d9b942c02af9a7c4
> > 7fa69baf29de8c77a6b32c054df2abb8f11f8aa4
> 
> OK, thanks for narrowing this down, I'll have a look at it shortly.

I can reproduce the problem, but it seems to affect USB controllers only
and, interestingly enough, it doesn't affect the EHCI controller on my test
system.  So, it seems to be specific to USB at least to some extent.

Thanks,
Rafael
