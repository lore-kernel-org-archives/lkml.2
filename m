Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab0JJGrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 02:47:51 -0400
Received: from mxout5.netvision.net.il ([194.90.9.29]:41943 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab0JJGru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 02:47:50 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Oct 2010 02:47:50 EDT
Content-transfer-encoding: 7BIT
From: Alon Ziv <alon+git@nolaviz.org>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alon Ziv <alon+git@nolaviz.org>
Subject: [PATCH 0/3] opticon driver fixes
Date: Sun, 10 Oct 2010 08:32:17 +0200
Message-id: <1286692340-18639-1-git-send-email-alon-git@nolaviz.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches get the opticon driver to actually work using my OPN2001.

A userspace library is still needed; a good start can be had using the
Python script from
http://majid.info/blog/a-python-driver-for-the-symbol-cs-1504-bar-code-scanner/

Alon Ziv (3):
  Fix long-standing bugs in opticon driver
  Add Opticon OPN2001 write support
  Whitespace fixes in opticon driver

 drivers/usb/serial/opticon.c |   44 +++++++++++++++++++++++++++++++----------
 1 files changed, 33 insertions(+), 11 deletions(-)

