Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198Ab0FVJbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 05:31:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36878 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759183Ab0FVJbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 05:31:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Tue, 22 Jun 2010 11:29:42 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <20100621055522.GE9735@gvim.org> <Pine.LNX.4.44L0.1006211125470.1687-100000@iolanthe.rowland.org> <20100622015837.GC12795@gvim.org>
In-Reply-To: <20100622015837.GC12795@gvim.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006221129.43216.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010, mark gross wrote:
> On Mon, Jun 21, 2010 at 11:57:21AM -0400, Alan Stern wrote:
> > On Sun, 20 Jun 2010, mark gross wrote:
... 
> > I don't know -- I have never looked at the Android userspace.  No doubt 
> > Arve can provide some examples.
> who are you?  You don't know about the Android stack, and you keep
> blowing about how suspend blockers solve all the PM problems?  I'm
> starting to think your just trolling. 

And that's just an excellent way of convincing people that you're right.  Guess
how it worked on me.

For your information, Alan is one of the people most actively engaged in
power management development at the kernel level and his ideas have heavily
influenced the design of the I/O runtime PM framework, among other things.

I certainly appeciate Alan's opinions very much, because he usually is
technically right.

Thanks,
Rafael
