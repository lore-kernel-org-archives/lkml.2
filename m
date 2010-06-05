Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab0FELKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 07:10:37 -0400
Received: from smtp-out11.han.skanova.net ([195.67.226.200]:34134 "EHLO
	smtp-out11.han.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751940Ab0FELKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 07:10:36 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Jun 2010 07:10:35 EDT
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 0/3] input: evdev: Dynamic buffers (rev4)
Date: Sat,  5 Jun 2010 13:04:26 +0200
Message-Id: <1275735869-2185-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

Please find enclosed the fourth version of the evdev buffer patches.

This version implements buffer locking using event_lock as you
suggested, such that we can proceed with fixing the evdev buffer
problem independently from providing a suitable one-to-many buffer.

The first patch converts the per-client buffers to a common buffer,
and adds a fixme since the code is expected to be further
improved. The second and third patch includes your review comments.

Thanks,
Henrik

---

Henrik Rydberg (3):
  input: evdev: Use multi-reader buffer to save space (rev4)
  input: evdev: Convert to dynamic event buffer (rev4)
  input: Use driver hint to compute the evdev buffer size (rev2)

 drivers/input/evdev.c |   68 +++++++++++++++++++++++++++++++++----------------
 include/linux/input.h |   17 ++++++++++++
 2 files changed, 63 insertions(+), 22 deletions(-)

