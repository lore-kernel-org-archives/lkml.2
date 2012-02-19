Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab2BSOYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 09:24:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49271 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab2BSOYd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 09:24:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kartiksinghal@gmail.com designates 10.50.36.230 as permitted sender) smtp.mail=kartiksinghal@gmail.com; dkim=pass header.i=kartiksinghal@gmail.com
MIME-Version: 1.0
From: Kartik Singhal <kartiksinghal@gmail.com>
Date: Sun, 19 Feb 2012 19:54:11 +0530
Message-ID: <CAAY3Td5hFQUaJP_BTNo9JJpqYPQ2TbfSXOU94zrvzHOUSGjsOA@mail.gmail.com>
Subject: make config errors while building kernel on Fedora 16 64-bit
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I tried to build both linux mainline and linux-next on my Fedora 16
box. But in both cases I am running into errors in making the .config.
I have tried with defconfig (make defconfig), xconfig, gconfig,
config, etc. all give the same errors.

I cloned from repo url's given at kernel.org using the following commands:

nohup git clone -v
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git &>
linux.log &

and

nohup git clone -v
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git &>
linux-next.log &


Here is a what is written (partial from top) to stdout:

*** Default configuration is based on 'x86_64_defconfig'
init/Kconfig:237:warning: multi-line strings not supported
kernel/irq/Kconfig:75:warning: multi-line strings not supported
init/Kconfig:667:warning: multi-line strings not supported
init/Kconfig:1216:warning: multi-line strings not supported
init/Kconfig:1307:warning: multi-line strings not supported
init/Kconfig:1308:warning: multi-line strings not supported

And the following (partial from bottom) to stderr:

drivers/lguest/Kconfig:15: syntax error
drivers/lguest/Kconfig:14: unknown option "If"
lib/xz/Kconfig:59: syntax error
lib/xz/Kconfig:58: unknown option "Unless"
lib/xz/Kconfig:59: unknown option "and"
lib/Kconfig:281: syntax error
lib/Kconfig:280: unknown option "If"
make[1]: *** [defconfig] Error 1
make: *** [defconfig] Error 2

I have verified that I have buildtools, kernel-devel and header
packages. Google search and asking on kernelnewbies list didn't help
either. Last month I had successfully built the kernel (mainline) for
first time on Linux Mint. But here, probably, I am missing something
completely. Please help.

--
Kartik
http://k4rtik.wordpress.com/
