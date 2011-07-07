Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab1GGGTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 02:19:11 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60995 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202Ab1GGGTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 02:19:08 -0400
Message-ID: <4E154FD8.8010604@kernel.dk>
Date: Thu, 07 Jul 2011 08:19:04 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] compat_ioctl: fix make headers_check regression
References: <20110704134842.7ab89126.sfr@canb.auug.org.au> <20110704100316.GA15894@sig21.net>
In-Reply-To: <20110704100316.GA15894@sig21.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-04 12:03, Johannes Stezenbach wrote:
> Fix headers_check error introduced by 390192b30057:
> 
> include/linux/fd.h:6: included file 'linux/compat.h' is not exported

Thanks!

-- 
Jens Axboe

