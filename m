Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561Ab2DJW3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 18:29:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54615 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab2DJW3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 18:29:23 -0400
From: Josenivaldo Benito Junior <jrbenito@benito.qsl.br>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Cc: Franco Catrin <fcatrin@gmail.com>,
        Josenivaldo Benito Junior <jrbenito@benito.qsl.br>
Subject: [PATCH 0/3] RESEND Aureal special HID driver
Date: Tue, 10 Apr 2012 19:29:03 -0300
Message-Id: <1334096946-18788-1-git-send-email-jrbenito@benito.qsl.br>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <alpine.LNX.2.00.1204090207090.24006@pobox.suse.cz>
References: <alpine.LNX.2.00.1204090207090.24006@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a RESEND of hid-aureal patch with Jiri´s suggestions applied.
It applies over linux-next-20120410 tag of linux-next tree.

Hid-aureal special HID driver is intend to correct a bogus HID descritor 
reported by Aureal IR based remote controllers.

Josenivaldo Benito Junior (3):
  Aureal Remote Control Device Driver
  HID: hid-core: Adding hid-aureal special driver
  HID: hid-aureal: Removing excessive dmesg information

 drivers/hid/Kconfig      |    6 +++++
 drivers/hid/Makefile     |    1 +
 drivers/hid/hid-aureal.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-core.c   |    1 +
 drivers/hid/hid-ids.h    |    3 ++
 5 files changed, 65 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hid/hid-aureal.c

-- 
1.7.5.4

