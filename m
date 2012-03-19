Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab2CSWUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:20:47 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39929 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719Ab2CSWUp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:20:45 -0400
Date: Mon, 19 Mar 2012 18:17:29 -0400 (EDT)
Message-Id: <20120319.181729.1955474261915960216.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: bjorn@mork.no, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] net: qmi_wwan: fix build error due to cdc-wdm dependecy
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F679437.8030201@xenotime.net>
References: <20120319184830.fce597a16eaf7206195a7a45@canb.auug.org.au>
	<1332179309-4163-1-git-send-email-bjorn@mork.no>
	<4F679437.8030201@xenotime.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 19 Mar 2012 15:17:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Mon, 19 Mar 2012 13:16:55 -0700

> On 03/19/2012 10:48 AM, Bjørn Mork wrote:
> 
>> Fixes:
>> 
>> drivers/built-in.o: In function `qmi_wwan_bind_shared':
>> qmi_wwan.c:(.text+0x25b686): undefined reference to `usb_cdc_wdm_register'
>> make[1]: *** [.tmp_vmlinux1] Error 1
>> 
>> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
>> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> 
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Applied.
