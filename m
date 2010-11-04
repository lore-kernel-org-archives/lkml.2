Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab0KDPLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:11:06 -0400
Received: from smtp.nokia.com ([147.243.128.24]:45993 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751811Ab0KDPK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:10:59 -0400
From: Heikki Krogerus <heikki.krogerus@nokia.com>
To: cbouatmailru@gmail.com
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, ameya.palande@nokia.com,
        markus.lehtonen@nokia.com, heikki.krogerus@nokia.com
Subject: [PATCH 0/3] isp1704 changes
Date: Thu,  4 Nov 2010 16:31:45 +0200
Message-Id: <1288881109-18222-1-git-send-email-heikki.krogerus@nokia.com>
X-Mailer: git-send-email 1.7.1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These add support for USB Host/HUB chargers and fix a few
issues.

Ameya Palande (1):
  power_supply: isp1704: correct length for storing model

Heikki Krogerus (2):
  power_supply: isp1704: Detect HUB/Host chargers
  power_supply: isp1704: Set isp->dev before anything needs it

 drivers/power/isp1704_charger.c |  188 ++++++++++++++++++++++++++++++---------
 1 files changed, 146 insertions(+), 42 deletions(-)

