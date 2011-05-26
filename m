Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab1EZDa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 23:30:27 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59500 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab1EZDaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 23:30:23 -0400
X-Nat-Received: from [202.181.97.72]:65063 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1306380621.23150
Message-Id: <201105260330.p4Q3ULQK073745@www262.sakura.ne.jp>
Subject: [initramfs] unpack_to_rootfs() should print error messages upon OOM.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 26 May 2011 12:30:21 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 26052011 #5433493, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried to install Fedora-15-i386-DVD.iso (which uses a 2.6.38 kernel) on a VM
with 512MB of RAM. The boot process stopped after printing

   Trying to unpack rootfs image as initramfs...

. The cause was RAM was not sufficient. It seems that Fedora 15 requires
more than 640MB of RAM to unpack the initramfs.

I think we should print error messages when unpacking the initramfs cannot be
completed due to insufficient RAM.
