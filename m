Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087Ab0EYVOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 17:14:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39477 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758533Ab0EYVOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 17:14:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Date: Tue, 25 May 2010 23:15:09 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
References: <Pine.LNX.4.44L0.1005251359580.1634-100000@iolanthe.rowland.org> <201005252221.55888.rjw@sisk.pl> <20100525204405.GE4455@core.coreip.homeip.net>
In-Reply-To: <20100525204405.GE4455@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005252315.09981.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 May 2010, Dmitry Torokhov wrote:
> On Tue, May 25, 2010 at 10:21:55PM +0200, Rafael J. Wysocki wrote:
> > On Tuesday 25 May 2010, Dmitry Torokhov wrote:
...
> > Now, we can reject their patches, but that's not going to cause any progress
> > to happen, realistically.  Quite on the contrary, Android will continue to use
> > wakelocks and Android driver writers will continue to ignore the mainline
> > and the gap between the two kernel lines will only get wider and wider over
> > time.
> > 
> > And what really is the drawback if we merge the patches?  Quite frankly,
> > I don't see any.
> 
> Adding stuff that is not beneficial to anyone but a particular platform?
> It is uncommon to say the least.

Well, not quite.  We have a number of platform-specific drivers for one
example.

Also, In fact I think it would benefit everyone if Android users could run
mainline kernels without major modifications on their systems.

Also, I think it would benefit everyone if Android drivers were merged into
the mainline.

Moreover, I think this stuff may actually be useful to someone beyond Android,
because it's proven working and people can readily play with it.  Which is not
going to happen if it's not in the mainline.

And I don't believe a user space power manager is going to be implemented
in a platform-idependent way, if at all (assuming we reject the Android
patches).

Rafael
