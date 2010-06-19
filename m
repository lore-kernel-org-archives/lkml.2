Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab0FSCNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 22:13:54 -0400
Received: from core.signal11.us ([64.251.29.136]:41833 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab0FSCNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 22:13:52 -0400
From: Alan Ott <alan@signal11.us>
To: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org, Antonio Ospite <ospite@studenti.unina.it>
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v2 0/2] HID: hidraw documentation
Date: Fri, 18 Jun 2010 22:13:41 -0400
Message-Id: <1276913623-6126-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1276832283-12084-1-git-send-email-alan@signal11.us>
References: <1276832283-12084-1-git-send-email-alan@signal11.us>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jun 18 22:13:51 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c1c27df21751498212569
X-DSPAM-Factors: 27,
	Received*26+177, 0.01000,
	Cc*<alan, 0.01000,
	txt, 0.01000,
	txt, 0.01000,
	To*linux+input, 0.01000,
	To*Ospite+<ospite, 0.01000,
	References*git, 0.01000,
	from, 0.01000,
	of, 0.01000,
	References*alan+signal11.us>, 0.01000,
	Received*ESMTP, 0.01000,
	), 0.01000,
	), 0.01000,
	To*suse.cz>, 0.01000,
	Received*(c+76, 0.01000,
	Received*242.hsd1.fl.comcast.net+[76.26.177.242]), 0.01000,
	References*send+email, 0.01000,
	Cc*Ott+<alan, 0.01000,
	files+changed, 0.01000,
	been, 0.01000,
	been, 0.01000,
	X-Mailer*email, 0.01000,
	From*<alan, 0.01000,
	References*1+git, 0.01000,
	X-Mailer*git+send, 0.01000,
	References*email+alan, 0.01000,
	changed, 0.01000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add the hidraw.txt file to a new Documentation/hid/ directory.

The example program has been moved out of the document and fixed up for style
(it's now checkpatch.pl clean), and a Makefile has been created for it.

I integrated the comments provided.

hiddev.txt has been moved from Documentation/usb/ to Documentation/hid/


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


