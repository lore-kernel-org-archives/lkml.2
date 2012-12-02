Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2LBXr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 18:47:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:54879 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab2LBXrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 18:47:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,202,1355126400"; 
   d="scan'208";a="225588363"
Date: Mon, 3 Dec 2012 00:47:42 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mfd: sta2x11-mfd: fix potential NULL pointer
 dereference in __sta2x11_mfd_mask()
Message-ID: <20121202234742.GZ3176@sortiz-mobl>
References: <CAPgLHd_0FZAtGnshNqD3RkGD9Qr+85vfxd2joSoc4U6Ef8JdKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd_0FZAtGnshNqD3RkGD9Qr+85vfxd2joSoc4U6Ef8JdKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Sun, Dec 02, 2012 at 08:36:22AM -0500, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> The dereference to 'mfd' should be moved below the NULL test.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/mfd/sta2x11-mfd.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
