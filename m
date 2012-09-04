Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab2IDBTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 21:19:14 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62523 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2IDBTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 21:19:13 -0400
Date: Mon, 3 Sep 2012 21:19:10 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        klmckinney1@gmail.com
Subject: Re: [PATCH] Staging: bcm: fix possible memory leak in
 bcm_char_ioctl()
Message-ID: <20120904011909.GA4010@gmail.com>
References: <CAPgLHd9HKqsyBydFpCHpcWmY4n2b_2kmZYKPsGfHFKNkiQJLAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd9HKqsyBydFpCHpcWmY4n2b_2kmZYKPsGfHFKNkiQJLAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 06:02:23PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> psFwInfo has been allocated in this function and should be
> freed before leaving from the error handling cases.
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/staging/bcm/Bcmchar.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
> index cf411d1..3d02c2e 100644
> --- a/drivers/staging/bcm/Bcmchar.c
> +++ b/drivers/staging/bcm/Bcmchar.c

Acked-by: Kevin McKinney <klmckinney1@gmail.com>
