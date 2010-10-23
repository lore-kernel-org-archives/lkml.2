Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab0JWSoG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 14:44:06 -0400
Received: from mxout5.netvision.net.il ([194.90.9.29]:62112 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190Ab0JWSoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 14:44:05 -0400
Content-transfer-encoding: 7BIT
From: Alon Ziv <alon+git@nolaviz.org>
To: linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Alon Ziv <alon+git@nolaviz.org>
Subject: [PATCH v2 0/2] Further cleanups to opticon driver
Date: Sat, 23 Oct 2010 20:43:27 +0200
Message-id: <1287859409-13810-1-git-send-email-alon-git@nolaviz.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches clean up the opticon driver to modern standards.

Alon Ziv (2):
  Export usb_serial_generic_write_room for use in other modules
  opticon: use generic code where possible

 drivers/usb/serial/generic.c |    1 +
 drivers/usb/serial/opticon.c |  411 +++++-------------------------------------
 2 files changed, 45 insertions(+), 367 deletions(-)

