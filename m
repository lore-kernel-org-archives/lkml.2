Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab0GTS6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 14:58:25 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:2632 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab0GTS6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 14:58:15 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L5VE0U-02-35O-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/10] x86, xsave: some code cleanups and reworks
Date: Tue, 20 Jul 2010 20:50:47 +0200
Message-ID: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains some cleanups and reworks I made during
code review and feature implementation for upcoming cpus.

Most patches refactor the xsave initialization that is very dependent
on fpu initialization. This series starts to decouple this a little
bit as xsave not only supports fpu features. Also this is an attempt
to ease the xsave interface by making some of the functions and
variables static.

There is also one patch that removes boot_cpu_id variable, which is
not really related to xsave. Maybe this should be applied to another
branch.

The patches are relative to today's tip/x86/xsave branch.

(The patches are small for better review and rebasing.)

-Robert


