Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946Ab0D3XIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 19:08:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32917 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386Ab0D3XIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 19:08:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: mgross@linux.intel.com
Subject: Re: [PATCH]PM QOS refresh against next-20100430
Date: Sat, 1 May 2010 01:08:28 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Kevin Hilman <khilman@deeprootsystems.com>, aili@codeaurora.org,
       dwalker@codeaurora.org, tiwai@suse.de, bruce.w.allan@intel.com,
       davidb@quicinc.com, mcgrof@gmail.com, pavel@ucw.cz,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, NetDev <netdev@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
References: <20100430212043.GA30315@linux.intel.com> <201005010013.16262.rjw@sisk.pl> <20100430230529.GA31391@linux.intel.com>
In-Reply-To: <20100430230529.GA31391@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005010108.28593.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 May 2010, mark gross wrote:
> On Sat, May 01, 2010 at 12:13:16AM +0200, Rafael J. Wysocki wrote:
> > On Friday 30 April 2010, mark gross wrote:
> > > The following is a refresh of the PM_QOS implementation, this patch
> > > updates some documentation input I got from Randy.
> > > 
> > > This patch changes the string based list management to a handle base
> > > implementation to help with the hot path use of pm-qos, it also renames
> > > much of the API to use "request" as opposed to "requirement" that was
> > > used in the initial implementation.  I did this because request more
> > > accurately represents what it actually does.
> > > 
> > > Also, I added a string based ABI for users wanting to use a string
> > > interface.  So if the user writes 0xDDDDDDDD formatted hex it will be
> > > accepted by the interface.  (someone asked me for it and I don't think
> > > it hurts anything.)
> > > 
> > > I really would like to get this refresh taken care of.  Its been taking
> > > me too long to close this.  please review or include it in next.
> > > 
> > > Thanks!
> > 
> > Well, I'd take it to suspend-2.6/linux-next, but first, it touches
> > subsystems whose maintainers were not in the Cc list, like the network
> > drivers, wireless and ACPI.  The changes are trivial, so I hope they don't
> > mind.
> > 
> > Second, my tree is based on the Linus' tree rather than linux-next and
> > the change in net/mac80211/scan.c doesn't seem to match that.  Please tell me
> > what I'm supposed to do about that.
> 
> You can waite for monday and I'll send a rebased version to linus' tree.
> 
> I thought linux-next was where folks wanted me to put it.
> 
> I'll email out a new one monday.

Great, thanks!

Rafael
