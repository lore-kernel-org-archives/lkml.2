Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751027Ab1DFEYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 00:24:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54094 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab1DFEYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 00:24:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [RFC][PATCH] PM / Platform: Remove __weak definitions of runtime PM callbacks
Date: Wed, 6 Apr 2011 06:24:23 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org
References: <201103270058.41632.rjw@sisk.pl> <201103282143.58477.rjw@sisk.pl> <BANLkTi=oFuSRSCLZRGwZACioCxO0WSYsOQ@mail.gmail.com>
In-Reply-To: <BANLkTi=oFuSRSCLZRGwZACioCxO0WSYsOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104060624.23692.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 05, 2011, Magnus Damm wrote:
> On Tue, Mar 29, 2011 at 4:43 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, March 28, 2011, Magnus Damm wrote:
> >> On Sun, Mar 27, 2011 at 8:58 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >> >
> >> > Remove the __weak definitions of platform bus type runtime PM
> >> > callbacks, make platform_dev_pm_ops point to the generic routines
> >> > as appropriate and allow architectures using platform_dev_pm_ops to
> >> > replace the runtime PM callbacks in that structure with their own
> >> > set.
> >> >
> >> > Convert architectures providing its own definitions of the platform
> >> > runtime PM callbacks to use the new mechanism.
> >> >
> >> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> >>
> >> Looking good, thanks Rafael. Tested on the sh7372 Mackerel board.
> >>
> >> Acked-by: Magnus Damm <damm@opensource.se>
> >
> > Thanks, I'll put it into my for-2.6.40 queue as soon as 2.6.39-rc1 is out.
> 
> Thanks. By the way, I think the symbols should be converted to static
> as well. Do you prefer to make a V2 or shall we do that incrementally?

I can fold that changed into the patch as I haven't pushed it yet.

Thanks,
Rafael
