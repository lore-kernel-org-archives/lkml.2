Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0KWM1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 07:27:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55659 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab0KWM1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 07:27:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=HH/q4zMLswPT7BNZQZlZDFuwxg2AcPHJo+7pSdGbkXAU6MBUkzaEGSJXu03+g2wn0h
         lKgk/FXXrytcS2AUTu6AJhPEWLDNZjtf75f72fSBP6K0hAqfUrMXCxxYMYL6/q4IB7Io
         8PaEqioQRBUUZHGNQ443DSfVxAbH6hPASZEIY=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 0/6] Add misc device handling.
Date: Tue, 23 Nov 2010 13:29:27 +0100
Message-Id: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch series use misc device instead of character device
creation by kernel space (which is obvious obsolete and wrong).
We add limitation for maximum 3 devices to be connected simultaneously.
This interface is used only for testing and not influence basic device 
functionality.

Marek Belisko (6):
  staging: ft1000: Remove functions which create devices in kernel
    space.
  staging: ft1000: Use misc device instead self created device.
  staging: ft1000: Remove unused variables.
  staging: ft1000: Remove unused headers.
  staging: ft1000: Remove dead code
  staging: ft1000: Check return value of ft1000_CreateDevice().

 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |  272 ++++++----------------
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c    |   11 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h   |    3 -
 3 files changed, 79 insertions(+), 207 deletions(-)

