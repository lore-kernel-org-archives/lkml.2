Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab1KHNfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 08:35:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51390 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab1KHNfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 08:35:14 -0500
From: Michal Simek <monstr@monstr.eu>
To: devicetree-discuss@lists.ozlabs.org
Cc: grant.likely@secretlab.ca, john.williams@petalogix.com,
        michal.simek@petalogix.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, jacmet@sunsite.dk, arnd@arndb.de
Subject: [RFC 0/2] serial: OF alias support
Date: Tue,  8 Nov 2011 14:35:05 +0100
Message-Id: <1320759307-24877-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am sending two patches for uartlite and uart16550/8250
serial drivers. 

Our aim is to be able to probe serial drivers based 
on order in alias node. We are using of_alias_get_id function
to get correct ID. 

These patches are based on the latest Linaro git tree 
(git://git.linaro.org/kernel/linux-linaro-3.1.git).
"Merge branch 'devicetree/arm-linaro-3.1' of git://git.secretlab.ca/git/linux-2.6 into linaro-3.1"
(sha1: af1bdb79ca64ceadc7b44b11929b384eff66ce59)

Thanks for you comments,
Michal

Michal Simek (2):
  serial: Add OF alias support for uartlite
  serial: 8250: Add OF alias support

 drivers/tty/serial/8250.c      |    7 +++++++
 drivers/tty/serial/of_serial.c |   15 +++++++++++++++
 drivers/tty/serial/uartlite.c  |   26 ++++++++++++++++++++++----
 3 files changed, 44 insertions(+), 4 deletions(-)

-- 
1.7.5.4

