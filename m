Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab2CSWEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:04:16 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:17791 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab2CSWEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:04:11 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: kconfig-frontends: a packaging of the kconfig language
Date: Mon, 19 Mar 2012 23:04:06 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.11-treguer; KDE/4.4.5; x86_64; ; )
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203192304.06397.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All!

I am glad to announce the kconfig-frontends' first release ever!

kconfig-frontends-3.3.0-0 was released today, right after the corresponding
Linux kernel was released! Go download it there:

  http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.3.0-0.tar.xz

The kconfig-frontends (temporary) home is at:

  http://ymorin.is-a-geek.org/projects/kconfig-frontends

The kconfig-frontends project aims at centralising the effort of keeping an
up-to-date, out-of-tree, packaging of the kconfig infrastructure, ready for
use by third-party projects.

The kconfig-frontends package provides the kconfig parser, as well as all
the frontends, packaged using the traditional autotools, so the kconfig
infrastructure is easy to deploy, either locally or system-wide.

What you get with kconfig-frontends:
  - all five frontends: conf, mconf, nconf, gconf and qconf
  - a shared and/or static library and the headers for the parser, so any
    one can build their own frontend
  - the standard "./configure && make && make install" dance
  - an easy way to sync from a newer kernel
  - a bit of documentation

kconfig-frontends is not meant to replace the in-tree Linux kconfig (at
least in the foreseeable future!), but really targets third-party projects
that want an easy path to following the evolution of kconfig, without the
burden to manually synchronise occasionally.

The plans for the future are:
  - release with every Linux kernel dot-0 release
  - release with every Linux kernel dot-release if there are kconfig fixes
  - release to fix blocking issues with the packaging
  - find a proper home (mid-term)
  - migrate the repository to git (short-term)
  - improve the documentation!

Any comment, any feedback is welcome! ;-)

Note: kconfig-frontends is only about the kconfig language: the parser and
the frontends; it's not about kbuild, the Linux kernel build infrastructure.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
