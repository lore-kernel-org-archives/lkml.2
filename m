Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab2AHM3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 07:29:50 -0500
Received: from claw.goop.org ([74.207.240.146]:58085 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab2AHM3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 07:29:48 -0500
Message-ID: <4F098C29.9010101@goop.org>
Date: Sun, 08 Jan 2012 23:29:29 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID
References: <alpine.LNX.2.00.1201052218200.24984@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1201052218200.24984@pobox.suse.cz>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2012 08:39 AM, Jiri Kosina wrote:
> Jeremy Fitzhardinge (3):
>       HID: debugfs: decode Generic Device Controls Usage Page
>       HID: hid-input: add support for HID devices reporting Battery Strength
>       HID: hid-input: fix compile for !HID_BATTERY_STRENGTH
>

This pull fixes Apple bluetooth keyboards and touchpads; they were
posted and acked, so I suspect you just overlooked them?

The following changes since commit e0273728564a395a13cfed70e34da4f2613d2d44:

  Merge branches 'hyperv', 'multitouch', 'roccat', 'upstream', 'upstream-fixes', 'wacom' and 'wiimote' into for-linus (2012-01-05 15:51:02 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git hid-battery

Daniel Nicoletti (1):
      hid-input: add support for HID devices reporting Battery Strength

Jeremy Fitzhardinge (7):
      hid-input/battery: remove apparently redundant kmalloc
      hid-input/battery: add quirks for battery
      hid-input/battery: deal with both FEATURE and INPUT report batteries
      hid-input/battery: make the battery setup common for INPUTs and FEATUREs
      hid-input/battery: power-supply type really *is* a battery
      hid-input/battery: remove battery_val
      hid-input/battery: add FEATURE quirk

 drivers/hid/hid-core.c  |    2 +-
 drivers/hid/hid-ids.h   |    1 +
 drivers/hid/hid-input.c |  113 +++++++++++++++++++++++++++++++++++------------
 include/linux/hid.h     |    5 ++-
 4 files changed, 91 insertions(+), 30 deletions(-)

I also have a branch at
  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git hid-battery-scope

which is based on the power supply scope changes in the battery.git tree; I'm not quite
sure how to sequence that into mainline.

Thanks,
	J

