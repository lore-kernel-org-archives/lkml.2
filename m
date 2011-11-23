Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759649Ab1KWKBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:01:32 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:41677 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245Ab1KWKB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:01:26 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] multitouch updates (mainly eGalax) 
Date: Wed, 23 Nov 2011 10:54:26 +0100
Message-Id: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

Here are some multitouch updates.
Jiri, the first one is already in your upstream-fixes branch, but not in
your for-next branch...

Patch 0002 will help end-users to test their device without recompiling the
hid-multitouch between each test.

Patches 0003-0008 are focused on eGalax: 
* I made some cleanup in the #defines for the PIDS.
* I removed the MT_QUIRK_EGALAX_XYZ_FIXUP as I understood why it was needed
* I also removed the .maxcontact field in EGALAX as it is not necessary
  (it was tested on 3 devices: Acer Iconia W500 by Marek, 0xa001 by Cedric,
   and Windpad 110W by me)
* I added a few new devices (I included the one reported by Marek and I kept
  his "From")
* I included the new protocol for a001 devices (reported by Cedric)

Cheers,
Benjamin


