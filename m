Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab2DEPO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:14:28 -0400
Received: from hosting.xaranet.de ([80.237.242.67]:55470 "EHLO
	hosting.xaranet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab2DEPO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 11:14:27 -0400
From: Guy Maurel <guy-kde@maurel.de>
To: linux-kernel@vger.kernel.org
Subject: a question of multi use of ptrace
Date: Thu, 5 Apr 2012 17:06:55 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.35-ARCH; KDE/4.8.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204051706.55314.guy-kde@maurel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Why isn't it possible to use gdb and strace at the same time on the same process? ie:
gdb --pid 1510
...
strace -p 1510
attach: ptrace(PTRACE_ATTACH, ...): Operation not permitted

Are there any people, any group, any work in progress to make this possible?
-- 
guy
