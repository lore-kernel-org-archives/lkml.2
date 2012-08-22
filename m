Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab2HVCxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 22:53:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37995 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab2HVCxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 22:53:02 -0400
Date: Tue, 21 Aug 2012 19:50:37 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Tony Luck <tony.luck@intel.com>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>
Subject: linux-next: New tree -- linux-pstore.git
Message-ID: <20120822025037.GA18807@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

Can you please add linux-pstore.git tree to the linux-next,
the repository address is as follows:

  git://git.infradead.org/users/cbou/linux-pstore.git master

This tree is dedicated to track pstore infrastructure fixes and
enhancements, currently it holds these commits:

Anton Vorontsov (3):
      pstore/ram: Fix possible NULL dereference
      pstore/ram: Mark ramoops_pstore_write_buf() as notrace
      MAINTAINERS: Add pstore maintainers

Jovi Zhang (1):
      pstore/ram: Add missing platform_device_unregister

Randy Dunlap (1):
      pstore/ram: Fix printk format warning


Thanks!

Anton.
