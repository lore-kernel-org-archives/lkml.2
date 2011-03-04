Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197Ab1CDUsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 15:48:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52834 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760167Ab1CDUsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 15:48:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kees Cook <kees.cook@canonical.com>
Subject: Re: [PATCH] power: disable hibernation if module loading is disabled
Date: Fri, 4 Mar 2011 21:48:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7+; KDE/4.4.4; x86_64; ; )
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
References: <1299255084-4390-1-git-send-email-segoon@openwall.com> <20110304184324.GQ372@outflux.net>
In-Reply-To: <20110304184324.GQ372@outflux.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103042148.39944.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 04, 2011, Kees Cook wrote:
> On Fri, Mar 04, 2011 at 07:11:24PM +0300, Vasiliy Kulikov wrote:
> > If /proc/sys/kernel/modules_disabled is set to 1, then nobody (even full
> > root) may not read/write arbitrary kernel memory.  In spite of it,
> > hibernation allows anyone with an access to either /dev/snapshot or
> > /sys/power/ make the full snapshot of the system.  This snapshot may be
> > freely changed and uploaded back.
> 
> Ah, yes please. I'd like to try to have ways to close all the
> "intentional" arbitrary memory writing interfaces.

They are not exactly arbitrary and I'd like to see a plausible attack
scenario using the hibernation interface as is (assuming you're not a
full root at least).

> Hooking it to modules_disable seems as good as any other toggle.

You're kidding, aren't you?

> Still waiting to hear
> anything on this: http://article.gmane.org/gmane.linux.acpi.devel/49471

I personally don't think it's a good idea, but I'm not the maintainer of that
code.

Thanks,
Rafael
