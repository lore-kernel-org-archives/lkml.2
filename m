Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab0JDHwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 03:52:04 -0400
Received: from smtp.nokia.com ([192.100.105.134]:21989 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0JDHwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 03:52:03 -0400
From: "Krogerus Heikki (EXT-Teleca/Helsinki)" 
	<ext-heikki.krogerus@nokia.com>
To: cbouatmailru@gmail.com
Cc: linux-kernel@vger.kernel.org, ext-heikki.krogerus@nokia.com
Subject: [PATCH 0/2] minor changes to power_supply
Date: Mon,  4 Oct 2010 10:51:36 +0300
Message-Id: <1286178698-28428-1-git-send-email-ext-heikki.krogerus@nokia.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 04 Oct 2010 07:51:47.0239 (UTC) FILETIME=[FEDEE370:01CB6398]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <ext-heikki.krogerus@nokia.com>

Both of them only concern USB charging.


Heikki Krogerus (2):
  power_supply: add types for USB chargers
  power_supply: Introduce maximum current property

 drivers/power/power_supply_sysfs.c |    4 +++-
 include/linux/power_supply.h       |    6 +++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

