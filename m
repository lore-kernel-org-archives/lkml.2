Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab0IDNnb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 09:43:31 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:59849 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752781Ab0IDNn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 09:43:29 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 0/5] input: wacom: Initial support for Bamboo (rev3)
Date: Sat,  4 Sep 2010 15:42:58 +0200
Message-Id: <1283607783-29388-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Ort1d-0005Dd-Ac.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1Ort1d-0005Dd-Ac 8c57f594aece1306e36bd581b71b6353
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the fourth iteration of the Bamboo patches. Hopefully no big
surprises.  The ordering has changed to allow setting the pressure_max
which is not parsed in the hid function. Ping's button mapping has
been implemented, relying on middle-button emulation instead.  The
lowres quirks now apply to all touch devices in the family.

Cheers,
Henrik

Henrik Rydberg (4):
  input: wacom: Add fuzz parameters to features
  input: wacom: Collect device quirks into single function (rev2)
  input: wacom: Add support for the Bamboo Touch trackpad (rev4)
  input: wacom: Add a quirk for lowres Bamboo devices (rev2)

Ping Cheng (1):
  input: wacom: Parse the Bamboo device family

 drivers/input/tablet/wacom.h     |    1 +
 drivers/input/tablet/wacom_sys.c |   57 +++++++++++++-----
 drivers/input/tablet/wacom_wac.c |  123 +++++++++++++++++++++++++++++++++++++-
 drivers/input/tablet/wacom_wac.h |   14 ++++
 4 files changed, 176 insertions(+), 19 deletions(-)

