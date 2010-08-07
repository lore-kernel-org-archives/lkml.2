Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab0HGFEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 01:04:23 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49555 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab0HGFET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 01:04:19 -0400
Message-Id: <201008070504.o7754Daw083381@www262.sakura.ne.jp>
Subject: Re: tomoyo-init (tomoyo-tools) results in kernel panic on kernel 2.6.35-git2/3
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: kawime@gmx.de
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Sat, 07 Aug 2010 14:04:13 +0900
References: <op.vg0yh9gtgp7xae@127.0.0.1>
In-Reply-To: <op.vg0yh9gtgp7xae@127.0.0.1>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 06082010 #3879218, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Karsten Mehrhoff wrote:
> Hi, i just compiled the 2.6.35-git3 kernel on my computer using debian 64 bit
> as i did with all other kernels before.
> Booting the git2/3 kernel results in a kernel panic because of
> /sbin/tomoyo-init.
> 
> No problem with the 2.6.35 kernel.
> 
> I've to remane /sbin/tomoyo-init to boot the kernel.
> Now i purged tomoyo-tools version 2.2.0-20100225 (aptitude purge tomoyo-tool) and everything works ok.
> Sorry, i forgot to backup the tomoyo-init script.
> 
> $ uname -a
> Linux xxxxxx 2.6.35-git3 #4 SMP Fri Aug 6 15:22:08 CEST 2010 x86_64 GNU/Linux

Thank you for using TOMOYO. TOMOYO has changed a lot in 2.6.36. Therefore,
you need to upgrade tomoyo-tools package. I'm testing it now.
You can upgrade it by doing

# wget -O tomoyo-tools.tar.gz 'http://sourceforge.jp/projects/tomoyo/svn/view/trunk/2.3.x/tomoyo-tools.tar.gz?root=tomoyo&view=tar'
# tar -zxf tomoyo-tools.tar.gz
# make -C tomoyo-tools/ install

Then, please delete (or rename) /etc/tomoyo/ directory and run
/usr/lib/tomoyo/init_policy .

Please see http://tomoyo.sourceforge.jp/2.3/ for more information.

Thank you.
