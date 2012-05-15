Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab2EOPyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:54:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45520 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544Ab2EOPyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:54:02 -0400
Date: Tue, 15 May 2012 08:53:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Shuah Khan <shuahkhan@gmail.com>, Kees Cook <keescook@chromium.org>,
        Colin Cross <ccross@android.com>, devel@driverdev.osuosl.org,
        linaro-kernel@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sergiu Iordache <sergiu@chromium.org>, linux-kernel@vger.kernel.org,
        arve@android.com, Jesper Juhl <jj@chaosbits.net>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>, tony.luck@intel.com
Subject: Re: [PATCH 0/11] Merge ramoops and persistent_ram, generic pstore
 RAM backend
Message-ID: <20120515155357.GA24671@kroah.com>
References: <20120512001506.GA8653@lizard>
 <20120514155846.GA19538@kroah.com>
 <1337013022.2476.17.camel@lorien2>
 <20120514204531.GA13828@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120514204531.GA13828@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 01:45:31PM -0700, Anton Vorontsov wrote:
> On Mon, May 14, 2012 at 10:30:22AM -0600, Shuah Khan wrote:
> [...]
> > Anton! Is it safe to assume you are planning to cover the second feature
> > as well, in which case I can drop my plans to get this work done.
> 
> Yep, absolutely. I'm fully committed to add runtime logging support
> to pstore. Actually, I'll post patches pretty soon.

Care to redo the last 4 in this series as well, based on Kees's
comments?

thanks,

greg k-h
