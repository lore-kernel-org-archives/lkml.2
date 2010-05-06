Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819Ab0EFPXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:23:48 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:31162 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab0EFPXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:23:44 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i2a8h87h43h65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L20834-02-2QV-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [PATCH 0/7] oprofile/x86: fix cpu hotplug
Date: Thu, 6 May 2010 15:26:07 +0200
Message-ID: <1273152374-9392-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes oprofile cpu hotplug. The code was broken and
causing crashes due to uninitialized counter usage. This can be only
fixed with a code rework. The first patch is to avoid kernel crashes
during cpu hotplug. This is a small fix for linux-stable.

Ingo, I will send a separate pull request.

-Robert


