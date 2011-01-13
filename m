Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029Ab1AMQCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:02:31 -0500
Received: from adelie.canonical.com ([91.189.90.139]:50968 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962Ab1AMQC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:02:29 -0500
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/1] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
Date: Thu, 13 Jan 2011 10:02:21 -0600
Message-Id: <1294934542-2411-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set acpi_skip_timer_override to force ignoring BIOS
IRQ0 pin2 override. This fixes resume from suspend on
AMD based ThinkPad Edge 11,13,14 and 15.

Regards
Manoj Iyer
