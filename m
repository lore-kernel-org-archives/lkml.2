Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab1ADGAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 01:00:05 -0500
Received: from core.signal11.us ([64.251.29.136]:58053 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab1ADGAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 01:00:00 -0500
X-Greylist: delayed 1353 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Jan 2011 01:00:00 EST
From: Alan Ott <alan@signal11.us>
To: Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Antonio Ospite <ospite@studenti.unina.it>, Tejun Heo <tj@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH 0/1] hidraw: compat_ioctl for hidraw
Date: Tue,  4 Jan 2011 00:37:21 -0500
Message-Id: <1294119442-6827-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Jan  4 00:37:27 2011
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4d22b216251896001213644
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hidraw did not have a compat_ioctl set, causing ioctls to fail from 32-bit apps on 64-bit systems. This patch seems to make ioctls work from 32-bit apps.

I made this look like the one in drivers/input/joydev.c. I'm not 100% sure that this is all that needs to be done, so it'd be nice if someone could review it.

Alan Ott (1):
  hidraw: Added Compatibility ioctl() for 32-bit applications.

 drivers/hid/hidraw.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


