Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab2LOPnu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 10:43:50 -0500
Received: from mail-wi0-f194.google.com ([209.85.212.194]:65268 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab2LOPns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 10:43:48 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: kconfig-frontends-3.7.0.0 released
Date: Sat, 15 Dec 2012 16:43:36 +0100
User-Agent: KMail/1.13.5 (Linux/3.6.9-treguer; KDE/4.4.5; x86_64; ; )
Cc: lwn@lwn.net, "Yann E. MORIN" <yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201212151643.36850.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All!

I'm pleased to announce the release of kconfig-frontends 3.7.0.0!
Go download it there:
    http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.7.0.0.tar.xz
    http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.7.0.0.tar.bz2

The kconfig-frontends package provides the kconfig parser, as well as all the
kconfig frontends and utilities, packaged using the traditional autotools, so
the kconfig infrastructure is easy to deploy, either locally or system-wide.

What's new since 3.6.0.0:
  - updated from linux-3.7:
    - kconfig: replace 'oldnoconfig' with 'olddefconfig', and keep the old name as an alias
    - menuconfig: Assign jump keys per-page instead of globally
    - kconfig: document oldnoconfig to what it really does in conf.c
  - yet a bit more of Cygwin compatibility

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

