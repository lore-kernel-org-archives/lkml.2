Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab1C0UxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 16:53:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45938 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1C0Uw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 16:52:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.38-git18: Reported regressions from 2.6.37
Date: Sun, 27 Mar 2011 22:48:38 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
References: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera>
In-Reply-To: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103272248.38893.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 27, 2011, Rafael J. Wysocki wrote:
> This message contains a list of some regressions from 2.6.37,
> for which there are no fixes in the mainline known to the tracking team.
> If any of them have been fixed already, please let us know.
> 
> If you know of any other unresolved regressions from 2.6.37, please let us
> know either and we'll add them to the list.  Also, please let us know
> if any of the entries below are invalid.
> 
> Each entry from the list will be sent additionally in an automatic reply
> to this message with CCs to the people involved in reporting and handling
> the issue.
> 
> 
> Listed regressions statistics:
> 
>   Date          Total  Pending  Unresolved
>   ----------------------------------------
>   2011-03-27       88       26          26
>   2011-03-06       70       27          26
>   2011-02-21       51       18          17
>   2011-02-12       39       20          18
>   2011-02-03       19       11           7


I forgot to mention that the tracking of regressions from 2.6.36 is now closed
and the tracking of regressions from 2.6.38 is going to start after 2.6.39-rc1
has been released.

The meta-bug for the tracking of regressions from 2.6.38 is
https://bugzilla.kernel.org/show_bug.cgi?id=32012

Thanks,
Rafael
