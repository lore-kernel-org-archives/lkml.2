Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab0JHAKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:10:22 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:65526 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab0JHAKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:10:20 -0400
X-Nat-Received: from [202.181.97.72]:60390 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1286496613.12823
Message-Id: <201010080010.o980ADB8027880@www262.sakura.ne.jp>
Subject: Re: 2.6.36-rc7: kernel panic with SECURITY_TOMOYO=y
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: lists@nerdbynature.de
Cc: linux-kernel@vger.kernel.org, takedakn@nttdata.co.jp
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 08 Oct 2010 09:10:13 +0900
References: <alpine.DEB.2.01.1010071534370.21082@trent.utfs.org> <alpine.DEB.2.01.1010071637090.21082@trent.utfs.org>
In-Reply-To: <alpine.DEB.2.01.1010071637090.21082@trent.utfs.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 07102010 #4280474, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau wrote:
> Kernel panic - not syncing: Profile uersion 0 is not supported

Thank you for using TOMOYO.

Linux 2.6.36 includes TOMOYO 2.3 which is not compatible with
TOMOYO 2.2 included in Linux 2.6.30-2.6.35 .

You need to delete /etc/tomoyo/ directory and recreate it using
new userspace tools. Please see http://tomoyo.sourceforge.jp/2.3/ .

Regards.
