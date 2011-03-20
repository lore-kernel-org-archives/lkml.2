Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab1CTSy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 14:54:26 -0400
Received: from core.signal11.us ([64.251.29.136]:35955 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab1CTSyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 14:54:21 -0400
From: Alan Ott <alan@signal11.us>
To: Randy Dunlap <rdunlap@xenotime.net>, Jonathan Corbet <corbet@lwn.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Jiri Kosina <jkosina@suse.cz>, Alan Ott <alan@signal11.us>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefani Seibold <stefani@seibold.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v5 2/2] HID: Move hiddev.txt to the new Documentation/HID directory
Date: Sat, 19 Mar 2011 20:29:45 -0400
Message-Id: <1300580985-10726-3-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1297829209-10511-1-git-send-email-alan@signal11.us>
References: <1297829209-10511-1-git-send-email-alan@signal11.us>
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Mar 20 13:54:20 2011
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 4d864d5c84815941515586
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


