Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab1H2VFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:05:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59509 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1H2VFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:05:01 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Azael Avalos <coproscefalo@gmail.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/5] toshiba_acpi: Cleanup and TOS1900 device support
Date: Mon, 29 Aug 2011 16:04:50 -0500
Message-Id: <1314651895-24345-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

I've had these patches sitting around for a few weeks, waiting until I
had some time to do more investigation into hotkey support. I haven't
had time for that investigation yet, but I thought I'd go ahead and send
in these patches to get your feedback.

In spirit these are a continuation of Azael's previous work on TOS1900
device support, and in many ways are similar. This batch only focuses on
cleanup and getting TOS1900 support minimally functional within the
driver while minimizing changes to the hardware interaction. These
changes would serve as a starting point for further enhancements.

Azael and I are both interseted to know whether this is the direction
you'd like to see this driver take and whether any additional changes
are necessary.

Thanks,
Seth
