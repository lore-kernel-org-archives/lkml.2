Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab2JXP5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:57:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:65125 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933636Ab2JXP5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:57:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,640,1344236400"; 
   d="scan'208";a="210038497"
Date: Wed, 24 Oct 2012 17:57:07 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 177/193] net/nfc/llcp: remove CONFIG_EXPERIMENTAL
Message-ID: <20121024155707.GB5276@sortiz-mobl>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-178-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351022666-6960-178-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

On Tue, Oct 23, 2012 at 01:04:10PM -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> CC: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: "John W. Linville" <linville@tuxdriver.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  net/nfc/llcp/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
