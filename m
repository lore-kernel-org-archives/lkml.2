Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab2AHQpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 11:45:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238Ab2AHQpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 11:45:51 -0500
Date: Sun, 8 Jan 2012 17:45:45 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID
In-Reply-To: <4F098C29.9010101@goop.org>
Message-ID: <alpine.LNX.2.00.1201081739360.24984@pobox.suse.cz>
References: <alpine.LNX.2.00.1201052218200.24984@pobox.suse.cz> <4F098C29.9010101@goop.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jan 2012, Jeremy Fitzhardinge wrote:

> > Jeremy Fitzhardinge (3):
> >       HID: debugfs: decode Generic Device Controls Usage Page
> >       HID: hid-input: add support for HID devices reporting Battery Strength
> >       HID: hid-input: fix compile for !HID_BATTERY_STRENGTH
> >
> 
> This pull fixes Apple bluetooth keyboards and touchpads; they were
> posted and acked, so I suspect you just overlooked them?

Gah, you are right.

As the pull request is now on its way to Linus, I'll wait for him to pull 
and then include it in the next round (if Linus doesn't pull it himself on 
top of the hid.git pull).

Thanks for noticing, Jeremy.

> The following changes since commit e0273728564a395a13cfed70e34da4f2613d2d44:
> 
>   Merge branches 'hyperv', 'multitouch', 'roccat', 'upstream', 'upstream-fixes', 'wacom' and 'wiimote' into for-linus (2012-01-05 15:51:02 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git hid-battery
> 
> Daniel Nicoletti (1):
>       hid-input: add support for HID devices reporting Battery Strength
> 
> Jeremy Fitzhardinge (7):
>       hid-input/battery: remove apparently redundant kmalloc
>       hid-input/battery: add quirks for battery
>       hid-input/battery: deal with both FEATURE and INPUT report batteries
>       hid-input/battery: make the battery setup common for INPUTs and FEATUREs
>       hid-input/battery: power-supply type really *is* a battery
>       hid-input/battery: remove battery_val
>       hid-input/battery: add FEATURE quirk
> 
>  drivers/hid/hid-core.c  |    2 +-
>  drivers/hid/hid-ids.h   |    1 +
>  drivers/hid/hid-input.c |  113 +++++++++++++++++++++++++++++++++++------------
>  include/linux/hid.h     |    5 ++-
>  4 files changed, 91 insertions(+), 30 deletions(-)
> 
> I also have a branch at
>   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git hid-battery-scope
> 
> which is based on the power supply scope changes in the battery.git tree; I'm not quite
> sure how to sequence that into mainline.

I will look into it.

-- 
Jiri Kosina
SUSE Labs
