Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab2HVTEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:04:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39418 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab2HVTEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:04:08 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/2] SPI EEPROM / device tree interaction improvements.
Date: Wed, 22 Aug 2012 12:03:56 -0700
Message-Id: <1345662238-15211-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

A couple of patches that make using SPI EEPROMs Real Easy for me.

David Daney (2):
  misc/at25, dt: Improve at25 SPI eeprom device tree bindings.
  misc/at25: Add an .id_table to at25 to facilitate driver loading and
    binding.

 Documentation/devicetree/bindings/misc/at25.txt | 34 ++++++---
 drivers/misc/eeprom/at25.c                      | 91 ++++++++++++++++++-------
 2 files changed, 89 insertions(+), 36 deletions(-)

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
-- 
1.7.11.4

