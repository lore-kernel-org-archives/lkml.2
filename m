Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab1LNVGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:06:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603Ab1LNVGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:06:49 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mikew@google.com, x86@kernel.org, hpa@zytor.com
Subject: Update UEFI variable support 
Date: Wed, 14 Dec 2011 16:06:27 -0500
Message-Id: <1323896791-10858-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our EFI variable support is artifically limited at the moment. This patchset
adds support for arbitrary variable sizes, limited only by what the platform
supports. It also fixes a case where we were unnecessarily fiddling with
sysfs while in the process of shutting down or crashing, which triggered
some other issues.

