Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2ACRLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 12:11:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38623 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab2ACRLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 12:11:52 -0500
From: Olof Johansson <olof@lixom.net>
To: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v3 0/5] x86: efi: cleanups and basic 32/64 bit support
Date: Tue,  3 Jan 2012 09:11:17 -0800
Message-Id: <1325610682-24811-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.8.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a refactored series of cleanups with the 32/64-bit enablement at
the end. It should hopefully be significantly easier to review.

Changelog to the 32/64-bit patch is:
v3:
* Reorganized to a series of patches to make it easier to review, and
  do some of the cleanups I had left out before.

v2:
* Added graceful error handling for 32-bit kernel that gets passed
  EFI data above 4GB.
* Removed some warnings that were missed in first version.

