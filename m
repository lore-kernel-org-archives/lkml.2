Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab1HVSpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 14:45:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61348 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab1HVSpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 14:45:46 -0400
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
In-Reply-To: <CA+55aFwEgp=3F6uH198XuQR0=6Um-Kp+0Wjcm0Xv1WoHRveKXw@mail.gmail.com>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
	 <CA+55aFwEgp=3F6uH198XuQR0=6Um-Kp+0Wjcm0Xv1WoHRveKXw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Aug 2011 20:45:40 +0200
Message-ID: <1314038740.2531.8.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 22 août 2011 à 11:30 -0700, Linus Torvalds a écrit :
> On Fri, Aug 19, 2011 at 4:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > Reposting due to popular demand. Several other people are running
> > into the same problem with all kinds of software.
> 
> I have heard this several times now, but nobody actually ever says
> *what* is broken.
> 
> The Fedora people seem to have done the 2.6.40 thing without any
> actual reason, for example (the two programs they claim were broken
> were things that they had already fixed in rawhide, afaik).
> 
> I'm not at all interested in these kinds of "all kinds of software" reports.
> 
> Details. Examples. Name the f&*cking names already. Shame them publicly.

For example, all kind of management software from HP doesnt work, unless
we pretend to run a 2.6 kernel.

$ uname -a
Linux svivoipvnx001 3.0.0-08107-g97cd98f #1062 SMP Fri Aug 12 18:11:45
CEST 2011 i686 i686 i386 GNU/Linux

$ hpacucli ctrl all show

Error: No controllers detected.

$ rpm -qf /usr/sbin/hpacucli
hpacucli-8.75-12.0


