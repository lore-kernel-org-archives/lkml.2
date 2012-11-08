Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab2KHLwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 06:52:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:45055 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2KHLwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 06:52:11 -0500
Message-ID: <509B9CC2.4070502@kernel.dk>
Date: Thu, 08 Nov 2012 12:51:30 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: smani@micron.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mtip32xx: fix potential NULL pointer dereference
 in mtip_timeout_function()
References: <CAPgLHd96n4i905x6WdYtKM5wkSGo7V+zLKzE1mjCXBJ2v6-EbA@mail.gmail.com>
In-Reply-To: <CAPgLHd96n4i905x6WdYtKM5wkSGo7V+zLKzE1mjCXBJ2v6-EbA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-08 10:35, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> The dereference to port should be moved below the NULL test.
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)

Thanks, it definitely doesn't make sense to check for !port after having
dereferenced it. Applied.

-- 
Jens Axboe

