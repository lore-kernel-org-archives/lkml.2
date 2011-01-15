Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab1AOUYN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 15:24:13 -0500
Received: from adelie.canonical.com ([91.189.90.139]:47313 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab1AOUYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 15:24:12 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: Andy Whitcroft <apw@canonical.com>, linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] sysrq is half-enabled by default
Date: Sat, 15 Jan 2011 20:23:56 +0000
Message-Id: <1295123037-2649-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that recent cleanups to sysrq handling have lead to us having
two copies of the sysrq enable status.  At boot these are currently
inconsistently specified leading to sysrq actually being enabled but
reported as not enabled in sysfs.  Following this email is a patch to
link both of these copies to a common configuration setting.

-apw

Andy Whitcroft (1):
  Input: sysrq -- ensure sysrq_enabled and __sysrq_enabled are
    consistent

 drivers/tty/sysrq.c |    2 +-
 kernel/sysctl.c     |    3 ++-
 lib/Kconfig.debug   |    9 +++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

-- 
1.7.2.3

