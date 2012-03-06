Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab2CFDaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 22:30:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39570 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab2CFDah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 22:30:37 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 0/3] Expanded hotkey support
Date: Mon,  5 Mar 2012 21:30:30 -0600
Message-Id: <1331004633-11862-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <20120305220407.GA16312@ubuntu-macmini>
References: <20120305220407.GA16312@ubuntu-macmini>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New version of the patches which remove the need to modify the EC
driver.

Changes since v3:

 * Drop patch to add ec_get_handle()
 * Use acpi_get_devices() to get EC handle

Thanks,
Seth


Azael Avalos (1):
  toshiba_acpi: Support additional hotkey scancodes

Seth Forshee (2):
  toshiba_acpi: Support alternate hotkey interfaces
  toshiba_acpi: Refuse to load on machines with buggy INFO
    implementations

 drivers/platform/x86/Kconfig        |    1 +
 drivers/platform/x86/Makefile       |    4 +
 drivers/platform/x86/toshiba_acpi.c |  260 ++++++++++++++++++++++++++++++-----
 3 files changed, 228 insertions(+), 37 deletions(-)

