Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687Ab2CWTc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:32:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301Ab2CWTcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:32:55 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: airlied@redhat.com, ajax@redhat.com
Subject: Handle multi-GPU EFI systems better 
Date: Fri, 23 Mar 2012 15:32:34 -0400
Message-Id: <1332531158-2319-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now we assume that the GPU with the legacy VGA routing is the active
video device. This holds for BIOS systems, but falls down quite badly on
EFI-based systems. This patchset adds support for cleaning that up and
has been confirmed to work on an Apple machine with dual GPUs.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

