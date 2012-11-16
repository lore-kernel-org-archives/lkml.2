Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab2KPSVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:21:08 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39135 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab2KPSVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:21:06 -0500
Message-ID: <1353090016.10872.81.camel@cumari.coelho.fi>
Subject: Re: [PATCH 020/104] drivers/net/wireless/ti/wl1251: remove depends
 on CONFIG_EXPERIMENTAL
From: Luciano Coelho <coelho@ti.com>
To: Kees Cook <keescook@chromium.org>
CC: <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 16 Nov 2012 20:20:16 +0200
In-Reply-To: <1352156701-4038-21-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
	 <1352156701-4038-21-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 15:03 -0800, Kees Cook wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> 
> CC: Luciano Coelho <coelho@ti.com>
> CC: "John W. Linville" <linville@tuxdriver.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Applied and pushed to the wl12xx.git tree, thanks!

--
Luca.

