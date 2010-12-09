Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab0LIVJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:09:00 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56021 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab0LIVI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:08:59 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6192"; a="65990748"
Date: Thu, 9 Dec 2010 13:08:57 -0800
From: David Brown <davidb@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Jiri Kosina <trivial@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: [PATCH 06/15] serial: Remove duplicate unlikely from IS_ERR
Message-ID: <20101209210857.GA11077@huya.qualcomm.com>
References: <cover.1291923888.git.joe@perches.com>
 <102d208d9a7b0de018361a71875da14eab0df2ec.1291923889.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <102d208d9a7b0de018361a71875da14eab0df2ec.1291923889.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 12:03:59PM -0800, Joe Perches wrote:

> IS_ERR already uses unlikely, remove unlikely from the call sites.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/serial/msm_serial.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Tobias Klauser <tklauser@distanz.ch> already posted a patch about
this.  They are identical, so I'll grab the first one from Tobias.

Thanks,
David
