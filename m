Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0LMI3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 03:29:53 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:48132 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793Ab0LMI3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 03:29:51 -0500
Message-ID: <4D05D966.5080104@euromail.se>
Date: Mon, 13 Dec 2010 09:29:26 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] input: mt updates for 2.6.38
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PS3mm-0006HA-B6.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PS3mm-0006HA-B6 1549b01eee17ebf2ddc23be30a95a8b5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/input-mt.git next

to receive input-mt updates for 2.6.38.

The changes have all been discussed on the list, and are mostly janitory in nature.

Thanks,
Henrik

Dmitry Torokhov (2):
      Input: include MT library as source for kerneldoc
      Input: document new trkid field in struct input_dev

Henrik Rydberg (3):
      input: mt: Move input MT header inside input directory
      input: mt: Interface and MT_TOOL documentation updates
      input: mt: Support separate contact and finger count reports

 Documentation/DocBook/device-drivers.tmpl    |    4 ++
 Documentation/input/multi-touch-protocol.txt |   39 ++++++++++++++++++--------
 drivers/hid/hid-3m-pct.c                     |    4 +-
 drivers/hid/hid-egalax.c                     |    4 +-
 drivers/input/input-mt.c                     |   35 +++++++++++++++++------
 drivers/input/input.c                        |    2 +-
 drivers/input/misc/uinput.c                  |    2 +-
 drivers/input/tablet/wacom_wac.c             |    4 +-
 drivers/input/touchscreen/wacom_w8001.c      |    2 +-
 include/linux/input.h                        |    7 ++--
 include/linux/{input-mt.h => input/mt.h}     |    3 +-
 11 files changed, 72 insertions(+), 34 deletions(-)
 rename include/linux/{input-mt.h => input/mt.h} (89%)
