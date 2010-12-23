Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0LWPV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 10:21:27 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:42057 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277Ab0LWPV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 10:21:26 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 23 Dec 2010 16:20:31 +0100
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] input: mt updates for 2.6.38
Message-ID: <20101223152031.GA1755@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13)
 Gecko/20101208 Thunderbird/3.1.7
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PVmy8-0006tg-Af.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PVmy8-0006tg-Af e67027b767eb369ff549777818dd1d41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/input-mt.git next

to receive input-mt updates for 2.6.38.

The device properties are in there, the synaptics patches are in
there, and another wetab patch is in there.

Merry Christmas,
Henrik

Andy Ross (1):
      hid: egalax: Add support for Wetab (726b)

Henrik Rydberg (6):
      Input: introduce device properties
      Input: fix double equality sign in uevent
      input: mt: Document interface updates
      Input: synaptics - report clickpad property
      Input: synaptics - add multi-finger and semi-mt support
      Input: synaptics - ignore bogus mt packet

 Documentation/input/multi-touch-protocol.txt |   44 +++++++-----
 drivers/hid/hid-core.c                       |    1 +
 drivers/hid/hid-egalax.c                     |    2 +
 drivers/hid/hid-ids.h                        |    1 +
 drivers/input/evdev.c                        |    4 +
 drivers/input/input.c                        |   21 ++++++-
 drivers/input/misc/uinput.c                  |    4 +
 drivers/input/mouse/synaptics.c              |   95 ++++++++++++++++++++++++--
 drivers/input/mouse/synaptics.h              |    3 +
 include/linux/input.h                        |   16 ++++
 include/linux/uinput.h                       |    1 +
 11 files changed, 168 insertions(+), 24 deletions(-)
