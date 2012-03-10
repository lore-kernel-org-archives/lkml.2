Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab2CJSyL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 13:54:11 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38313 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2CJSyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 13:54:06 -0500
From: Alan Ott <alan@signal11.us>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH 0/1] ARM: AT91: drivers: cleanup patches from Arnd Bergmann
Date: Sat, 10 Mar 2012 13:53:37 -0500
Message-Id: <1331405617-4053-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm helping Arnd Bergmann get some of his cleanup patches upstream. This
covers the AT91 related drivers.

Thanks,

Alan.

Arnd Bergmann (1):
  ata: AT91 ata driver requires specific platforms

 drivers/ata/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

