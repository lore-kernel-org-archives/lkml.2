Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2EZNI1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:08:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49889 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2EZNIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:08:25 -0400
Date: Sat, 26 May 2012 06:06:50 -0700
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
Subject: [PATCH 0/5] Some pstore/ramoops fixes
Message-ID: <20120526130650.GA6242@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

In the light of Linus' response, and I said this to Colin already, I'll
just zap a prz at boot time for pstore/console interface, which means
that nowadays there shouldn't be any objections to this bunch of fixes.

These are valid fixes for v3.5, they restore old pstore's behavior
nuances, which I changed accidentaly.

Except for the last patch, which is just a fix I happened to make when
I got bored of the warning. :-) Not a regression fix, though.

Thanks,

---
 fs/pstore/inode.c          |    2 +-
 fs/pstore/ram.c            |    3 +++
 fs/pstore/ram_core.c       |   27 +++++++++++++++++----------
 include/linux/pstore_ram.h |    2 ++
 4 files changed, 23 insertions(+), 11 deletions(-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
