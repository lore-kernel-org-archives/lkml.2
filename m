Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab0KIQzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:55:35 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:51705 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753091Ab0KIQze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:55:34 -0500
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX18OqzAA/r4OP94zkQpDMwppA5UffF8pX5frAzkqyt
	xhz17fyppTDhy9
From: Alexey Fisher <bug-track@fisher-privat.net>
To: <linux-kernel@vger.kernel.org>
Cc: Alexey Fisher <bug-track@fisher-privat.net>
Subject: [PATCH 0/2] FAT unified kernel messages
Date: Tue,  9 Nov 2010 17:55:16 +0100
Message-Id: <1289321718-6373-1-git-send-email-bug-track@fisher-privat.net>
X-Mailer: git-send-email 1.7.1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
i do not know best place to send patches for FAT fs, so i send it here.
This patchset add function fat_msg and remplace all printk to use it.
The major differnce is - it add device name to all messages. 

For example old log:
 FAT: im filed.
new one:
 FAT-fs (sda1): im filed.

Second reson is, to make FAT logs more grep frendly. So you can grep by "-fs"
for (EXT[4,3,2] and FAT), or by device.
