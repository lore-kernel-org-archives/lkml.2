Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab2EPPbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:31:07 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:19908 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab2EPPbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:31:01 -0400
Message-ID: <1337182252.2424.18.camel@lorien2>
Subject: Re: [PATCH 2/6] pstore/ram: Add console messages handling
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: shuahkhan@gmail.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Date: Wed, 16 May 2012 09:30:52 -0600
In-Reply-To: <20120516125634.GB20475@lizard>
References: <20120516125330.GA15460@lizard> <20120516125634.GB20475@lizard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 05:56 -0700, Anton Vorontsov wrote:
> This is all straightforward: we just use the last region for
> console logging. If there's just one region, we fall-back to
> the old behaviour: just a oops/dumps logging.

What about the saving /proc/last_kmsg? Are you not bringing that feature
from ramconsole? Sorry if I missed it in reading the patches.

-- Shuah


