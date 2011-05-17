Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab1EQWlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:41:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33401 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab1EQWlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:41:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@gmail.com
Subject: Re: [PATCH v2 3/3] PM / DEVFREQ: add sysfs interface (including user tickling)
Date: Wed, 18 May 2011 00:41:57 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@sirena.org.uk>,
        Jiejing Zhang <kzjeef@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Colin Cross <ccross@google.com>, Nishanth Menon <nm@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <1305100723-29161-1-git-send-email-myungjoo.ham@samsung.com> <20110511225540.GA3492@suse.de> <BANLkTik__9G-DuSsT_kAc69d+5g8xcVyFg@mail.gmail.com>
In-Reply-To: <BANLkTik__9G-DuSsT_kAc69d+5g8xcVyFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105180041.57723.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 17, 2011, MyungJoo Ham wrote:
> On Thu, May 12, 2011 at 7:55 AM, Greg KH <gregkh@suse.de> wrote:
> > On Wed, May 11, 2011 at 04:58:43PM +0900, MyungJoo Ham wrote:
> >> 1. System-wide sysfs interface
> >> - tickle_all  R: number of tickle_all execution
> >>               W: tickle all devfreq devices
> >> - min_interval        R: devfreq monitoring base interval in ms
> >> - monitoring  R: shows whether devfreq monitoring is active or
> >>   not.
> >>
> >> 2. Device specific sysfs interface
> >> - tickle      R: number of tickle execution for the device
> >>               W: tickle the device
> >
> > Any sysfs file change/addition/removal needs to have a
> > Documentation/ABI/ entry as well.  Please add that to this patch instead
> > of burying it in the changelog entry, where no one will be able to find
> > it in the future.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Sure, I'll add Documentation/ABI/testing/* entries.
> 
> However, would it be appropriate for "1. System-wide sysfs interface"
> to be in "sysfs-class-power" and for "2. Device specific sysfs
> interface" to be in "sysfs-devices-devfreq"?
> 
> System-wide sysfs interface is in /sys/class/power/devfreq/* and

Hmm.  Why not to use /sys/power/ that's already there?

> Device specific sysfs interface is in /sys/...DEVICE.../devfreq/* .

Thanks,
Rafael
