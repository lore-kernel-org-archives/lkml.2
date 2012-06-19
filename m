Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2FSCMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:12:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40004 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2FSCMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:12:43 -0400
Date: Mon, 18 Jun 2012 19:10:51 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 0/7] pstore/ram: Early registration and configurable ECC
 buffers size
Message-ID: <20120619021050.GA19387@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here are some more updates for the pstore/ram: it is implementation
of Colin Cross's and Arve Hjønnevåg's suggestions, i.e. early probing
and configurable ECC size. The last one needed quite a bit of cleanups
in the core code, though.

Thanks,

---
 fs/pstore/ram.c            |   77 ++++++++++++++++++++++----------------------
 fs/pstore/ram_core.c       |   65 ++++++++++++++++++++-----------------
 include/linux/pstore_ram.h |   11 +++----
 3 files changed, 79 insertions(+), 74 deletions(-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
