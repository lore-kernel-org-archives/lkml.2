Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab1AKXol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 18:44:41 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45245 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab1AKXob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:44:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ge5vhpGFeH+AiIoVJsVMSISocRFwBL+MjXgiPR//lHsnMXAseymB7jIR+oPhXb4eNV
         u4I0UNCsdQESQaPcLDpV+li4zjAL8bp8Vm7CWv2ZUfKfeA8yEgGt52IddZABeGPLr7zh
         4ziXcZFJe9XIswL2mXhuKvsbGFWw0V0g9PwtE=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Alex Dubov <oakad@yahoo.com>
Subject: [PATCH V2 0/4]: MEMSTICK: My 2 drivers for 2.6.38 inclusion
Date: Wed, 12 Jan 2011 01:36:11 +0200
Message-Id: <1294788975-19584-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, this is pretty much same version  as I sent yestarday.
I did a proofread of the commit messages, did a review of ms_block.c
during which I found misspelled debug message, and verified
that my port to sg_mitter in code that fills the sg with 0xFF
really works. 

This is pretty much merge worthy.

patch 1 - only commit message change
patch 2 - unchanged
patch 3 - commit message change + trivial string change
patch 4 - fix for a typo in contents



