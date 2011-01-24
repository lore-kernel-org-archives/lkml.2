Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1AXP0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:26:15 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44560 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab1AXP0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:26:13 -0500
From: Borislav Petkov <bp@amd64.org>
To: <x86@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/7] x86, microcode, AMD: Some fixes
Date: Mon, 24 Jan 2011 16:28:56 +0100
Message-Id: <1295882943-11184-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

this is a small patchset that takes care of various smallish issues with
the AMD microcode driver, see the individual commit messages for more
info.

Suggestions and comments are welcome, as always.

 arch/x86/kernel/microcode_amd.c  |  142 ++++++++++++++++++--------------------
 arch/x86/kernel/microcode_core.c |    6 +-
 drivers/base/sys.c               |   65 ++++++++++++-----
 3 files changed, 118 insertions(+), 95 deletions(-)

Thanks,
Boris.
