Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab0LIKYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:24:36 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:36647 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab0LIKYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:24:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=qR4SHOnvx+b07j2zbC0AOiJuz+5FDVJQVAaC1IpVtv587O/hyHUOLOae6vs2iJI/LV
         cpV6gQXg47Qv2RomkvbhP7iJASJO6uLxB8Z1+kCWZrFclAJ1fl/XmeNUCNtc068p+3zd
         eJEKGNskA37bXSVJbX1VeoTB/RjXN0MElv2gg=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 0/8] Use debugfs for debugging purposes.
Date: Thu,  9 Dec 2010 11:26:45 +0100
Message-Id: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patches add basic support for debugfs usage instead
character device. Creation of file and directory in debugfs 
depend on every device plugged in the system. 

Also basic cleanups was made. File operations functionality is not
yet checked and patches will follow.

Marek Belisko (8):
  staging: ft1000: Convert char device to debugfs.
  staging: ft1000: Fix private data pointer usage.
  staging: ft1000: Remove unused pdevobj array.
  staging: ft1000: Remove unused variable.
  staging: ft1000: Fix camelcase functions and variables.
  staging: ft1000: Remove dead code.
  staging: ft1000: Remove unused headers.
  staging: ft1000: Fix debug messages.

 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |  314 +++++++++-------------
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c    |    4 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c   |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h   |   13 +-
 4 files changed, 141 insertions(+), 192 deletions(-)

