Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab1BPEGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:06:54 -0500
Received: from core.signal11.us ([64.251.29.136]:48106 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353Ab1BPEGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:06:52 -0500
From: Alan Ott <alan@signal11.us>
To: Randy Dunlap <rdunlap@xenotime.net>, Alan Ott <alan@signal11.us>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, ospite@studenti.unina.it, linux-input@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bgood@velocity.net
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v4 0/2] HID: hidraw Documentation
Date: Tue, 15 Feb 2011 23:06:47 -0500
Message-Id: <1297829209-10511-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Feb 15 23:06:51 2011
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4d5b4d5b144701423591355
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I messed up a minute ago and sent just one of these out. Please disregard
the one I just sent that says v2. It should have been v3, and it should have
had 2 patches in the set instead of just 1. Sorry for the noise....

These patches add the hidraw.txt file to a new Documentation/hid/ directory.

The example program has been moved out of the document and fixed up for style
(it's now checkpatch.pl clean), and a Makefile has been created for it.

I integrated the comments provided.

hiddev.txt has been moved from Documentation/usb/ to Documentation/hid/

This is rebased against .37+



Alan Ott (2):
  HID: Documentation for hidraw
  HID: Move hiddev.txt to the new Documentation/HID directory

 Documentation/hid/Makefile            |    8 ++
 Documentation/hid/hid-example.c       |  167 +++++++++++++++++++++++++++++++++
 Documentation/{usb => hid}/hiddev.txt |    0
 Documentation/hid/hidraw.txt          |  119 +++++++++++++++++++++++
 4 files changed, 294 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/hid/Makefile
 create mode 100644 Documentation/hid/hid-example.c
 rename Documentation/{usb => hid}/hiddev.txt (100%)
 create mode 100644 Documentation/hid/hidraw.txt


