Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab1BPEH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:07:26 -0500
Received: from core.signal11.us ([64.251.29.136]:48131 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797Ab1BPEGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:06:53 -0500
From: Alan Ott <alan@signal11.us>
To: Randy Dunlap <rdunlap@xenotime.net>, Alan Ott <alan@signal11.us>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, ospite@studenti.unina.it, linux-input@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bgood@velocity.net
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v4 2/2] HID: Move hiddev.txt to the new Documentation/HID directory
Date: Tue, 15 Feb 2011 23:06:49 -0500
Message-Id: <1297829209-10511-3-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1297829209-10511-1-git-send-email-alan@signal11.us>
References: <1297829209-10511-1-git-send-email-alan@signal11.us>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Feb 15 23:06:53 2011
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4d5b4d5d144911355418074
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


