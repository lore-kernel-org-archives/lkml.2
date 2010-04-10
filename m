Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231Ab0DJICy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 04:02:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48843 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab0DJICt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 04:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hpnuuJ+l1+rLlAeQUsObNoxionXiB6G+/rH7zsfdfJbNw7njn++ktxITa7/TViZDfz
         RqWhyadsDi+TOaCzTebcWQrGHsWEvig4pHvC8SpqBtEghEte0c2+PZ5kHMpetFQcD/BH
         aouLs4tbS7tZC2Lx2mT1HGhHI9XZI2V3lb6Yo=
Date: Sat, 10 Apr 2010 16:06:31 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Janos Haar <janos.haar@netcenter.hu>
Cc: Christian Kujau <lists@nerdbynature.de>, david@fromorbit.com,
       axboe@kernel.dk, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
       linux-mm@kvack.org, xiyou.wangcong@gmail.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look
	please!...)
Message-ID: <20100410080631.GA9772@hack>
References: <20100402230905.GW3335@dastard> <22c901cad333$7a67db60$0400a8c0@dcccs> <20100404103701.GX3335@dastard> <2bd101cad4ec$5a425f30$0400a8c0@dcccs> <20100405224522.GZ3335@dastard> <3a5f01cad6c5$8a722c00$0400a8c0@dcccs> <20100408025822.GL11036@dastard> <00bb01cad70d$a814c2c0$0400a8c0@dcccs> <alpine.DEB.2.01.1004091435170.29272@bogon.housecafe.de> <099001cad836$39dc6860$0400a8c0@dcccs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <099001cad836$39dc6860$0400a8c0@dcccs>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 10, 2010 at 12:44:28AM +0200, Janos Haar wrote:
> Hello,
>

Hi,

> I am just started to test the stable-queue patch series on 2.6.32.10.
> Now running, we will see...
> The 2.6.33.2 made 4 crashes in the last 3 days. :-(
> This was more worse than the original 2.6.32.10.
>
> (I am very interested, anyway, this is the last shot of this server.
> The owner giving me an ultimate.
> If the server crashes again in the next week, i need to replace the 
> entire HW, the OS, and the services as well...)
>

I would recommend you to use a distribution-released kernel,
rather than a stable kernel from kernel.org, because usually
the distribution maintains a longer supported kernel than
kernel.org.

Just a little suggestion. Hope it helps for you to choose Linux. ;)

Thanks.

-- 
Live like a child, think like the god.
 
