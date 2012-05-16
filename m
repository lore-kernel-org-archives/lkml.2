Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967233Ab2EPNUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:20:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49209 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758381Ab2EPNUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:20:02 -0400
Date: Wed, 16 May 2012 06:19:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, patches@linaro.org,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        arve@android.com, Jesper Juhl <jj@chaosbits.net>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH v2 0/6] Merge ramoops and persistent_ram, generic pstore
 RAM backend
Message-ID: <20120516131958.GA28730@kroah.com>
References: <20120516124109.GA14658@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516124109.GA14658@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 05:41:09AM -0700, Anton Vorontsov wrote:
> Hi all,
> 
> Here is v2 of the previous patch set. The series do not include
> patches that were already merged.
> 
> I believe I addressed all the previous comments, plus now the
> series include another small cleanup patch.

I've applied patches 1 and 3 of this series to my staging-next tree, the
others would not apply due to the failure in patch 2.  Care to fix that
up and resend so that I can apply them?

thanks,

greg k-h
