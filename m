Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab2EFH5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 03:57:22 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43950 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929Ab2EFH5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 03:57:21 -0400
Message-ID: <1336291033.7955.0.camel@dabdike.home>
Subject: Re: [PATCH] Fix compile failure on PA-RISC
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Helge Deller <deller@gmx.de>
Cc: John David Anglin <dave.anglin@bell.net>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 06 May 2012 08:57:13 +0100
In-Reply-To: <4FA59A75.8080402@gmx.de>
References: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com>
	 <1798237.g4OIBKAx4s@donald.sf-tec.de>
	 <Pine.LNX.4.64.1205051445360.2623@file.rdu.redhat.com>
	 <BLU0-SMTP81AFFA5151451BADCB23B3972D0@phx.gbl> <4FA59A75.8080402@gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-05 at 23:24 +0200, Helge Deller wrote:
> On 05/05/2012 10:09 PM, John David Anglin wrote:
> > On 5-May-12, at 2:55 PM, Mikulas Patocka wrote:
> > 
> >> I acknowledge that your patches work. So send them directly to Linus. I
> >> think there is not much maintenance being done on PA-RISC.
> > 
> > James wrote back in March "I haven't yet actually tried git head on parisc
> > (and I won't be able to until I actually get my machines back [currently being
> > shipped across the atlantic]) but if there's a problem it will show up quickly:
> > parisc actually uses cpu hotplug to boot its secondary cpus."
> 
> > Helge resigned due to lack of time.
> 
> I'm still alive and was still reading the mailing list.
> And I'm planning to test some newer kernels very soon again :-)
> So, many thanks from my side to everyone who sent patches in the past
> (incl. Mikulas, Rolf and others).

If you could, it would help.  I still have no access to PA systems
(should have mine by next week), but I'm on holiday this week anyway.

James


