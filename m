Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab2B0QLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:11:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44813 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab2B0QK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:10:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of benmcollins13@gmail.com designates 10.68.130.234 as permitted sender) smtp.mail=benmcollins13@gmail.com; dkim=pass header.i=benmcollins13@gmail.com
From: Ben Collins <benmcollins13@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [Regression] powerpc/usb: fix issue of CPU halt when missing USB PHY clock
Date: Mon, 27 Feb 2012 11:10:55 -0500
Message-Id: <12BC8F06-26EE-4A58-8F0B-6D39C0DD7360@gmail.com>
Cc: linux-kernel@vger.kernel.org
To: Shengzhou Liu <Shengzhou.Liu@freescale.com>
Mime-Version: 1.0 (Apple Message framework v1257)
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The patch that checks the CTRL_PHY_CLK_VALID bit is failing incorrectly on my system (P4080DS). If I revert it, my system goes back to working correctly, but as is, it fails and wont allow my USB to work properly.

I've tried adding a loop to poll this bit 10,000 times with a udelay(1) on each loop and it still fails, so it doesn't appear to be a timing issue.

Is this check valid for all systems?

--
Bluecherry: http://www.bluecherrydvr.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/

