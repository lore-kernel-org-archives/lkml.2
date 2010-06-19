Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0FSCOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 22:14:17 -0400
Received: from core.signal11.us ([64.251.29.136]:41853 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627Ab0FSCNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 22:13:53 -0400
From: Alan Ott <alan@signal11.us>
To: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org, Antonio Ospite <ospite@studenti.unina.it>
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v2 2/2] HID: Move hiddev.txt to the new Documentation/HID directory
Date: Fri, 18 Jun 2010 22:13:43 -0400
Message-Id: <1276913623-6126-3-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1276832283-12084-1-git-send-email-alan@signal11.us>
References: <1276832283-12084-1-git-send-email-alan@signal11.us>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jun 18 22:13:52 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c1c27e021931520049671
X-DSPAM-Factors: 27,
	Received*26+177, 0.01000,
	Cc*<alan, 0.01000,
	txt, 0.01000,
	txt, 0.01000,
	To*linux+input, 0.01000,
	To*Ospite+<ospite, 0.01000,
	References*git, 0.01000,
	To*Randy+Dunlap, 0.01000,
	from, 0.01000,
	In-Reply-To*git+send, 0.01000,
	In-Reply-To*alan, 0.01000,
	References*alan+signal11.us>, 0.01000,
	To*suse.cz>+linux, 0.01000,
	Received*ESMTP, 0.01000,
	), 0.01000,
	), 0.01000,
	To*suse.cz>, 0.01000,
	Received*(c+76, 0.01000,
	Received*242.hsd1.fl.comcast.net+[76.26.177.242]), 0.01000,
	Date*Fri, 0.01000,
	References*send+email, 0.01000,
	Cc*Ott+<alan, 0.01000,
	files+changed, 0.01000,
	To*Randy, 0.01000,
	Received*Fri+18, 0.01000,
	X-Mailer*email, 0.01000,
	From*<alan, 0.01000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new Documentation/hid directory, it makes sense to have
hiddev.txt here as well.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 Documentation/{usb => hid}/hiddev.txt |    0
 1 files changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/{usb => hid}/hiddev.txt (100%)

diff --git a/Documentation/usb/hiddev.txt b/Documentation/hid/hiddev.txt
similarity index 100%
rename from Documentation/usb/hiddev.txt
rename to Documentation/hid/hiddev.txt
-- 
1.7.0.4


