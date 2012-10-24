Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935186Ab2JXQ3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:29:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:58760 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708Ab2JXQ3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:29:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,640,1344236400"; 
   d="scan'208";a="237635754"
Date: Wed, 24 Oct 2012 17:57:30 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 178/193] net/nfc/nci: remove CONFIG_EXPERIMENTAL
Message-ID: <20121024155730.GC5276@sortiz-mobl>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-179-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351022666-6960-179-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

On Tue, Oct 23, 2012 at 01:04:11PM -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> CC: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> CC: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  net/nfc/nci/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
