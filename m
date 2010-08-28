Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0H1O2j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 10:28:39 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:51975 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753546Ab0H1O2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 10:28:34 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 0/3] hid: 3m: Complete MT support
Date: Sat, 28 Aug 2010 16:27:29 +0200
Message-Id: <1283005652-3198-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OpMNk-000360-4d.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OpMNk-000360-4d a9d8a9e7729e6a18bc1c0d31c8ec0009
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri, Stephane, Dmitry,

Please find enclosed a set of patches which enables full support for
the 60-finger, 22-inch 3M touchscreen. Two of the patches fix actual
problems, and one patch converts the driver to the MT slots protocol.

The changes depend on two recent patches:
     - hid: Add a hid quirk for input sync override
     - input: mt: Initialize slots to unused

The tested hardware was provided by Canonical Ltd.

Cheers,
Henrik

Henrik Rydberg (3):
  hid: 3m: Adjust to sequential MT HID protocol
  hid: 3m: Convert to MT slots
  hid: 3m: Correct touchscreen emulation

 drivers/hid/hid-3m-pct.c |  111 +++++++++++++++++++++++++---------------------
 1 files changed, 61 insertions(+), 50 deletions(-)

