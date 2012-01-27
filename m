Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2A0Aqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 19:46:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57162 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab2A0Aqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 19:46:50 -0500
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [Patch 0/1] Bluetooth: Add support for BCM20702A0 [0a5c:21e1]
Date: Thu, 26 Jan 2012 18:46:38 -0600
Message-Id: <1327625199-10750-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please consider this patch to add vendor specific ID 
for BCM20702A0. This was tested by me on HP ProBook series, and found 
to work. 

For example.
With this quirk, hci tool is able to list devices correctly. 

$ hcitool dev 
Devices:
        hci0    60:D8:19:F0:3A:6D
 

