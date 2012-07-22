Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2GVN7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 09:59:37 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:34403 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab2GVN7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 09:59:35 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: kconfig-frontends-3.5.0-0 released
Date: Sun, 22 Jul 2012 15:59:31 +0200
User-Agent: KMail/1.13.5 (Linux/3.5.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207221559.31897.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All!

I'm pleased to announce the release of kconfig-frontends 3.5.0-0!
Go download it there:
    http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.5.0-0.tar.xz
    http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.5.0-0.tar.bz2

The kconfig-frontends package provides the kconfig parser, as well as all the
kconfig frontends and utilities, packaged using the traditional autotools, so
the kconfig infrastructure is easy to deploy, either locally or system-wide.

What's new since 3.4.0-0:
  - compiling on L10n-deffective systems has been fixed
  - compiling under Cygwin is mostly functional (except the nconf frontend)
  - the packaging has been enhanced and cleaned up
  - compilation logs are now more like the kernel's (using the autotools
    silent rules)
  - the streamline utility has been removed because it is too kernel-specific

As a reminder, the home for kconfig-frontends is:
  http://ymorin.is-a-geek.org/projects/kconfig-frontends

And the repository can be browsed or hg-cloned from:
  http://ymorin.is-a-geek.org/hg/kconfig-frontends

kconfig-frontends is not meant to replace the in-tree Linux kconfig, but
really targets third-party projects that want an easy path to following
the evolution of kconfig, without the burden to manually synchronise from
the Linux kernel source tree.

Any comment, any feedback, any patch is welcome! ;-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
