Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab2CIXcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 18:32:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59522 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2CIXcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 18:32:33 -0500
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH] thinkpad-acpi: recognize Lenovo as version string in newer V-series BIOS
Date: Fri,  9 Mar 2012 17:32:23 -0600
Message-Id: <1331335944-4662-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please consider this patch to thinkpad-acpi. This fixes failure to load
on the newer V series Lenovo thinkpads which report the product version
as Lenovo instead of ThinkPad. This Patch was tested by me and found
to work on my Lenovo V series sytem. 

Thanks
Manoj Iyer

