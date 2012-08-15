Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab2HOUKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:10:18 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:40964 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757054Ab2HOUKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:10:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Subject: Re: [PATCH] cpuidle: coupled: fix sleeping while atomic in cpu notifier
Date: Wed, 15 Aug 2012 22:16:10 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org
References: <1343251216-24106-1-git-send-email-ccross@android.com> <201208080015.31359.rjw@sisk.pl> <CAMbhsRT5pHkVWPf5u=+hqWhAgAD_kDb+DSSx+PG-nAJ5DHdhng@mail.gmail.com>
In-Reply-To: <CAMbhsRT5pHkVWPf5u=+hqWhAgAD_kDb+DSSx+PG-nAJ5DHdhng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208152216.10512.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 08, 2012, Colin Cross wrote:
> On Tue, Aug 7, 2012 at 3:15 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, July 25, 2012, Colin Cross wrote:
> >> The cpu hotplug notifier gets called in both atomic and non-atomic
> >> contexts, it is not always safe to lock a mutex.  Filter out all events
> >> except the six necessary ones, which are all sleepable, before taking
> >> the mutex.
> >>
> >> Signed-off-by: Colin Cross <ccross@android.com>
> >
> > Has this been applied already?
> 
> It's not in Linus' tree, and I haven't heard anything from Len.

Len appears to be unavailable.

I'll put it into the linux-next branch of the linux-pm.git tree and will
push it to Linus for -rc3 if Len doesn't show up till then.

Thanks,
Rafael
