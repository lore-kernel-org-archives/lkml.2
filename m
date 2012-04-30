Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2D3JPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 05:15:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:29968 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336Ab2D3JPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 05:15:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="159853021"
Date: Mon, 30 Apr 2012 11:15:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: joseph daniel <josephdanielwalter@gmail.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/nfc: Fix the compilation warning
Message-ID: <20120430091536.GB31528@sortiz-mobl>
References: <1335771795-18961-1-git-send-email-josephdanielwalter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1335771795-18961-1-git-send-email-josephdanielwalter@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joseph,

On Mon, Apr 30, 2012 at 01:43:15PM +0600, joseph daniel wrote:
> the nfc_llcp_general_bytes is defined in nfc/core.c as
>     static inline u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, size_t *gb_len).
> 
> as in nfc/nfc.h:
>     static inline u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, u8 *gb_len), as
>     CONFIG_NFC_LLCP is not defined.
> 
> so we got some warnings,
> net/nfc/core.c:207:2: warning: passing argument 2 of ‘nfc_llcp_general_bytes’ from incompatible pointer type [enabled by default]
> net/nfc/nfc.h:87:19: note: expected ‘u8 *’ but argument is of type ‘size_t *’
> 
> Signed-off-by: joseph daniel <josephdanielwalter@gmail.com>
Thanks, patch applied to my nfc-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
