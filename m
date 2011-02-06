Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1BFMbu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:31:50 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:32779 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1BFMbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:31:48 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.44
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>, Dmitry Torokhov <dtor@mail.ru>,
        Henrik Rydberg <rydberg@euromail.se>, Daniel Mack <daniel@caiaq.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] eeepc-wmi input patchs
Date: Sun,  6 Feb 2011 13:30:46 +0100
Message-Id: <1296995448-5591-1-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
These two patchs are separated from the other batch because they
may be delayed or re-worked.

The first patch add some camera specific keys, we can probably
use arrows and +/- to do the same thing, but then we loose some
keyboard information (eg: no distinction between Fn+E and Arrow Up).

The other patch only add some comments to some ambiguously mapped
keys. We may want to define to new key codes for these...

Corentin Chary (2):
  eeepc-wmi: add camera keys
  eeepc-wmi: comments keymap to clarify the meaning of some keys

 drivers/platform/x86/eeepc-wmi.c |   13 ++++++++++---
 include/linux/input.h            |    7 +++++++
 2 files changed, 17 insertions(+), 3 deletions(-)

-- 
1.7.4.rc3

