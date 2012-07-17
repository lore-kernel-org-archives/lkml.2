Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab2GQSTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:19:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34293 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab2GQSTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:19:48 -0400
Date: Tue, 17 Jul 2012 11:19:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, devel@driverdev.osuosl.org,
        linaro-kernel@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        linux-kernel@vger.kernel.org, arve@android.com,
        Jesper Juhl <jj@chaosbits.net>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] pstore: Headers should include all stuff they use
Message-ID: <20120717181944.GA21957@kroah.com>
References: <20120717180918.GA18671@lizard>
 <1342548840-22404-1-git-send-email-anton.vorontsov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342548840-22404-1-git-send-email-anton.vorontsov@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 11:13:59AM -0700, Anton Vorontsov wrote:
> Headers should really include all the needed prototypes, types, defines

<snip>

  Content-Transfer-Encoding: base64

That's not a nice way to send patches out, care to fix this and resend?

thanks,

greg k-h
