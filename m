Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab2DKSjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:39:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50184 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab2DKSja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:39:30 -0400
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org, Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [Patch 0/1] Bluetooth: btusb: Add vendor specific ID (0a5c:21f4) BCM20702A0
Date: Wed, 11 Apr 2012 13:39:22 -0500
Message-Id: <1334169563-2948-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please consider this patch to add vendor specific ID 
for BCM20702A0. Reported/Tested by Dennis Chua <dennis.chua@canonical.com>
on a Lenovo system.

root@u-k29-814ti006g:~# hcitool dev
Devices:
 hci0	E4:D5:3D:F1:55:84


