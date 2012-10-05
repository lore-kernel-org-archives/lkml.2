Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab2JEUoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 16:44:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56578 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932687Ab2JEUoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 16:44:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 00/10] Platform data clean-up and UIB device enablement
Date: Fri, 5 Oct 2012 19:53:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210051953.43586.arnd@arndb.de>
X-Provags-ID: V02:K0:tHTHDb4v0IExx/HsCljTXX0ZW5fQ8QpuQHZeR9f7pns
 Qabdy9FSlAv5z0DbKzVcDkjgTKiRN/Hz6zs77bKkzy7y5neMAF
 fgI4iHJ95EtUXWWH9A59SyAINjpYqjDVxltT3CdCE/M701D9gP
 xInghrVB9lw/X6ctxOJJcV5KWBFdlPzKrBZMIsra9MRkyl6Go4
 ZCaUVW9C8DhsSkZRQHZi6alV1Zwb6jyPbQFTKrrvmuaf5LVPrE
 T9f66l++oi9ZdZW5Hla7GrftQbjj3wWf2NeK+NTXOvPMI47q+j
 aHfdynFlOhAPn2BqzcB5SZWgY923cvQBUdIpU0o1NzJH8N/sC0
 HswI1/WPkQZ10oY6HKLg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 October 2012, Lee Jones wrote:
> In this patch-set we move all Device Tree start-up code from the u8500
> board file and into the more persistent db8500 cpu file. This will aid
> future endeavours to remove platform code completely from Mainline. We
> also enable some of the devices found on the STUIB (User Interface
> board), which attaches to some of ST-Ericsson's reference platforms.
> 

Looks all good to me.

Acked-by: Arnd Bergmann <arnd@arndb.de>
