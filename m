Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab2BYBWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 20:22:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33048 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab2BYBWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 20:22:07 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: balbi@ti.com
Cc: dahlmann.thomas@arcor.de, gregkh@linuxfoundation.org,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] drivers/usb/gadget/amd5536udc.c: code cleanup.
Date: Sat, 25 Feb 2012 02:14:56 +0100
Message-Id: <1330132502-17057-1-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series of patches cleans up drivers/usb/gadget/amd5536udc.c, fixing the 33
warnings returned by scripts/checkpatch.pl.

Patch 1/6 removes unneeded braces around one-line statements in if statements
and loops.
Patch 2/6 removes unneeded whitespaces before '\n' in various strings.
Patch 3/6 fixes the indentation of a block.
Patch 4/6 uses the DEFINE_PCI_DEVICE_TABLE macro rather than "const struct
pci_device_id".
Patch 5/6 fixes the type of the ep_string variable.
Patch 6/6 removes a CVS marker that is no longer relevant.

These patches should be trivial and unlikely to break anything.


Regards,
Cyril Roelandt.
