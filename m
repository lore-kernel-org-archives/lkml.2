Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1ITV4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:56:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48878 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1ITV4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:56:08 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Azael Avalos <coproscefalo@gmail.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] toshiba_acpi: Cleanup and TOS1900 device support
Date: Tue, 20 Sep 2011 16:55:48 -0500
Message-Id: <1316555754-25949-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

Please consider merging the following patches. They represent a
signficant cleanup of toshiba_acpi as well as adding support for SPFC as
an HCI method. The latter provides basic but functional support for the
TOS1900 devices found on newer Toshiba models, which will serve as a
good starting point for further enhancements. I've tried to leave the
details of the hardware interaction unchanged to reduce the risk of
regression for machines already supported by the driver.

The patches are virtually identical to the RFC series I had sent a while
back, but with an additional patch to initialize the brightness in the
backlight device. 

Thanks,
Seth
