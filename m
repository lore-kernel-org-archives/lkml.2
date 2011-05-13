Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab1EMAFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 20:05:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:16377 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759014Ab1EMAFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 20:05:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,361,1301900400"; 
   d="scan'208";a="746527069"
Subject: Re: [PATCH 1/9] iwlegacy: Silence DEBUG_STRICT_USER_COPY_CHECKS=y
 warning
From: wwguy <wey-yi.w.guy@intel.com>
To: Stephen Boyd <sboyd@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>
In-Reply-To: <1305244212-19183-2-git-send-email-sboyd@codeaurora.org>
References: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org>
	 <1305244212-19183-2-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 17:01:42 -0700
Message-ID: <1305244903.3589.0.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 16:50 -0700, Stephen Boyd wrote:
> Enabling DEBUG_STRICT_USER_COPY_CHECKS causes the following
> warning:
> 
> In file included from arch/x86/include/asm/uaccess.h:573,
>                  from include/net/checksum.h:25,
>                  from include/linux/skbuff.h:28,
>                  from drivers/net/wireless/iwlegacy/iwl-4965-rs.c:28:
> In function 'copy_from_user',
>     inlined from 'iwl4965_rs_sta_dbgfs_scale_table_write' at
>     drivers/net/wireless/iwlegacy/iwl-4965-rs.c:2616:
> arch/x86/include/asm/uaccess_64.h:65:
> warning: call to 'copy_from_user_overflow' declared with
> attribute warning: copy_from_user() buffer size is not provably
> correct
> 
> presumably due to buf_size being signed causing GCC to fail to
> see that buf_size can't become negative.
> 
> Cc: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/net/wireless/iwlegacy/iwl-4965-rs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
Stanislaw Gruszka <sgruszka@redhat.com> is the maintainer for iwlegacy

Thanks
Wey



