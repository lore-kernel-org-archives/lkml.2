Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab2ENUzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:55:41 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:12948 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab2ENUzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:55:40 -0400
Message-ID: <1337028933.3556.4.camel@lorien2>
Subject: Re: [PATCH 0/11] Merge ramoops and persistent_ram, generic pstore
 RAM backend
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: shuahkhan@gmail.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, patches@linaro.org,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sergiu Iordache <sergiu@chromium.org>, linux-kernel@vger.kernel.org,
        arve@android.com, Jesper Juhl <jj@chaosbits.net>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>, tony.luck@intel.com
Date: Mon, 14 May 2012 14:55:33 -0600
In-Reply-To: <20120514204531.GA13828@lizard>
References: <20120512001506.GA8653@lizard>
	 <20120514155846.GA19538@kroah.com> <1337013022.2476.17.camel@lorien2>
	 <20120514204531.GA13828@lizard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 13:45 -0700, Anton Vorontsov wrote:
> On Mon, May 14, 2012 at 10:30:22AM -0600, Shuah Khan wrote:
> [...]
> > Anton! Is it safe to assume you are planning to cover the second feature
> > as well, in which case I can drop my plans to get this work done.
> 
> Yep, absolutely. I'm fully committed to add runtime logging support
> to pstore. Actually, I'll post patches pretty soon.
> 
> Thanks!

Cool. Do you need any testing help? I have an interest in seeing this
work on architectures and platforms I play with.

-- Shuah


