Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab1CTAaM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 20:30:12 -0400
Received: from core.signal11.us ([64.251.29.136]:34597 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab1CTAaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 20:30:06 -0400
From: Alan Ott <alan@signal11.us>
To: Randy Dunlap <rdunlap@xenotime.net>, Jonathan Corbet <corbet@lwn.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Jiri Kosina <jkosina@suse.cz>, Alan Ott <alan@signal11.us>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefani Seibold <stefani@seibold.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v5 0/2] Documentation and Sample for hidraw
Date: Sat, 19 Mar 2011 20:29:43 -0400
Message-Id: <1300580985-10726-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1297829209-10511-1-git-send-email-alan@signal11.us>
References: <1297829209-10511-1-git-send-email-alan@signal11.us>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sat Mar 19 19:30:05 2011
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4d854a8d31303607281667
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I've been slack in getting v5 of this patch out. Because
it's been so long, I'll recap what happened last time:

 * Jon Corbet suggested that the example programs be moved into samples/ .
 * Randy Dunlap indicated his acked-by when this was done.

These patches add hidraw.txt to a new Documentation/hid/ directory.

It creates an example program which is now in samples/ with a Kconfig item.

The existing hiddev.txt has been moved from Documentation/usb/ to
Documentation/hid/

This is based on .38+

Alan Ott (2):
  HID: Documentation for hidraw
  HID: Move hiddev.txt to the new Documentation/HID directory

 Documentation/{usb => hid}/hiddev.txt |    0
 Documentation/hid/hidraw.txt          |  119 +++++++++++++++++++++++
 samples/Kconfig                       |    6 +
 samples/Makefile                      |    2 +-
 samples/hidraw/Makefile               |    8 ++
 samples/hidraw/hid-example.c          |  167 +++++++++++++++++++++++++++++++++
 6 files changed, 301 insertions(+), 1 deletions(-)
 rename Documentation/{usb => hid}/hiddev.txt (100%)
 create mode 100644 Documentation/hid/hidraw.txt
 create mode 100644 samples/hidraw/Makefile
 create mode 100644 samples/hidraw/hid-example.c


