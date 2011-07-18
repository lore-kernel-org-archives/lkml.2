Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1GRSHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 14:07:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57716 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab1GRSHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 14:07:20 -0400
Date: Mon, 18 Jul 2011 11:06:17 -0700 (PDT)
Message-Id: <20110718.110617.207141326101677046.davem@davemloft.net>
To: xiyou.wangcong@gmail.com
Cc: mmarek@suse.cz, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [Patch] include/linux/sdla.h: remove the prototype of sdla()
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAM_iQpWDrhHw8-Hf4q1miHR+rT33wQb=ZSb=ffsxaSak=UHPMw@mail.gmail.com>
References: <CAM_iQpWDrhHw8-Hf4q1miHR+rT33wQb=ZSb=ffsxaSak=UHPMw@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 18 Jul 2011 11:06:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Américo Wang <xiyou.wangcong@gmail.com>
Date: Sun, 17 Jul 2011 16:22:20 +0800

> `make headers_check` complains that
> 
> linux-2.6/usr/include/linux/sdla.h:116: userspace cannot reference
> function or variable defined in the kernel
> 
> this is due to that there is no such a kernel function,
> 
> void sdla(void *cfg_info, char *dev, struct frad_conf *conf, int quiet);
> 
> I don't know why we have it in a kernel header, so remove it.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

Applied, thanks.
