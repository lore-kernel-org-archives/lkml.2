Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab2EPQ3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 12:29:52 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:32671 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2EPQ3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 12:29:50 -0400
Message-ID: <1337185786.2424.31.camel@lorien2>
Subject: Re: [PATCH 4/6] staging: android: persistent_ram: Move to
 fs/pstore/ram_core.c
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: shuahkhan@gmail.com, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, patches@linaro.org,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        arve@android.com, Jesper Juhl <jj@chaosbits.net>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>
Date: Wed, 16 May 2012 10:29:46 -0600
In-Reply-To: <20120516150550.GA22945@kroah.com>
References: <20120516124109.GA14658@lizard> <20120516124338.GD18345@lizard>
	 <20120516150550.GA22945@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 08:05 -0700, Greg Kroah-Hartman wrote:

> 
> After applying this patch, and building things, I get the following
> errors:

Greg,

> What went wrong?
> 
> I've now applied the first 3 patches in this series to my tree, plus the
> 2 others from the linux-next tree, so care to just fix up these last
> three and resend them?

Picking [PATCH 5/6] staging/android: Remove ram_console driver should
fix this problem. This patches removes ram_console.c from the staging
area.

-- Shuah

