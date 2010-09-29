Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0I2PBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 11:01:17 -0400
Received: from xenotime.net ([72.52.115.56]:41469 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752452Ab0I2PBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 11:01:15 -0400
Date: Wed, 29 Sep 2010 08:01:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "N.P.S. N.P.S." <napohybelskurwysynom2010@gmail.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: mmotm 2010-09-28-16-13 uploaded
Message-Id: <20100929080113.5581c19d.rdunlap@xenotime.net>
In-Reply-To: <AANLkTinYExzihm6BuP=amLDwMO-zXejeUq5xeHL4ETg_@mail.gmail.com>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
	<AANLkTinYExzihm6BuP=amLDwMO-zXejeUq5xeHL4ETg_@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 15:13:41 +0200 N.P.S. N.P.S. wrote:

> 2010/9/29  <akpm@linux-foundation.org>:
> > The mm-of-the-moment snapshot 2010-09-28-16-13 has been uploaded to
> 
> Another randconfig thing
> 
> drivers/net/pch_gbe/pch_gbe_main.c: In function 'pch_gbe_tx_queue':
> drivers/net/pch_gbe/pch_gbe_main.c:965: error: implicit declaration of
> function 'tcp_hdr'
> drivers/net/pch_gbe/pch_gbe_main.c:965: error: invalid type argument
> of '->' (have 'int')
> drivers/net/pch_gbe/pch_gbe_main.c:968: error: invalid type argument
> of '->' (have 'int')
> drivers/net/pch_gbe/pch_gbe_main.c:976: error: implicit declaration of
> function 'udp_hdr'
> drivers/net/pch_gbe/pch_gbe_main.c:976: error: invalid type argument
> of '->' (have 'int')
> drivers/net/pch_gbe/pch_gbe_main.c:980: error: invalid type argument
> of '->' (have 'int')
> make[3]: *** [drivers/net/pch_gbe/pch_gbe_main.o] Error 1
> make[2]: *** [drivers/net/pch_gbe] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2

Patch has been sent to DaveM and he has merged it.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
