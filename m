Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab0LHJDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 04:03:33 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:56840 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631Ab0LHJD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 04:03:29 -0500
Message-ID: <4CFF49BC.8030202@euromail.se>
Date: Wed, 08 Dec 2010 10:02:52 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] input: mt updates for 2.6.38
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PQFvK-0006Zr-6j.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PQFvK-0006Zr-6j 5e5cbd0a3c048d94a975b1f35d3cf758
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/input-mt.git next

to receive input-mt updates for 2.6.38.

The tree contains core changes as well as dependent changes to hid drivers. You
also find the new hid-egalax driver in there, signed off by Jiri.

Thanks,
Henrik

Henrik Rydberg (13):
      input: mt: Break out slots handling
      input: mt: Collect slots initialization code
      input: mt: Add an envelope tool type
      input: mt: Move tracking and pointer emulation to input-mt
      input: mt: Add hovering distance axis
      hid: egalax: Setup input device manually
      hid: egalax: Correct for device resolution report error
      hid: egalax: Report zero as minimum pressure
      hid: egalax: Add event filtering
      hid: egalax: Convert to MT slots
      hid: egalax: Add support for Wetab
      hid: egalax: Document the new devices in Kconfig
      MAINTAINERS: Update input-mt entry

 Documentation/input/multi-touch-protocol.txt |   14 ++-
 MAINTAINERS                                  |    2 +
 drivers/hid/Kconfig                          |    3 +-
 drivers/hid/hid-3m-pct.c                     |   36 +------
 drivers/hid/hid-core.c                       |    1 +
 drivers/hid/hid-egalax.c                     |  127 +++++++++-------------
 drivers/hid/hid-ids.h                        |    1 +
 drivers/input/Makefile                       |    2 +-
 drivers/input/input-mt.c                     |  153 ++++++++++++++++++++++++++
 drivers/input/input.c                        |   48 +--------
 drivers/input/misc/uinput.c                  |    4 +-
 drivers/input/tablet/wacom_wac.c             |   26 +---
 drivers/input/tablet/wacom_wac.h             |    4 -
 drivers/input/touchscreen/wacom_w8001.c      |   25 +---
 include/linux/input-mt.h                     |   56 ++++++++++
 include/linux/input.h                        |   22 +---
 16 files changed, 306 insertions(+), 218 deletions(-)
 create mode 100644 drivers/input/input-mt.c
 create mode 100644 include/linux/input-mt.h
