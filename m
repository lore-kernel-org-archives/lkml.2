Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab2GIXsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:48:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54725 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab2GIXsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:48:00 -0400
Date: Mon, 9 Jul 2012 16:45:59 -0700
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
Subject: [PATCH resend 0/3] pstore/ram: Configurable ECC size
Message-ID: <20120709234559.GA22203@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Just a few patches left from the series that used to add configurable
ECC size for pstore/ram backend. Most patches were merged into -next,
and this is just a resend of the leftovers.

(Note that pstore/trace patches go on top of this series.)

Thanks,

---
 fs/pstore/ram.c            |   14 +++++++-------
 fs/pstore/ram_core.c       |   30 ++++++++++++++----------------
 include/linux/pstore_ram.h |    7 ++-----
 3 files changed, 23 insertions(+), 28 deletions(-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
