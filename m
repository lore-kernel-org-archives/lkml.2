Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab0LFSLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:11:12 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:60661 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab0LFSLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:11:10 -0500
Date: Mon, 6 Dec 2010 16:11:27 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Joe Perches <joe@perches.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] vsprintf: Add %pMbt, bluetooth mac address
Message-ID: <20101206181127.GB883@vigoh>
References: <cover.1291419007.git.joe@perches.com>
 <a33a0b00eeb29713a08d91156cbb2d816176f990.1291419007.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a33a0b00eeb29713a08d91156cbb2d816176f990.1291419007.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

* Joe Perches <joe@perches.com> [2010-12-03 18:33:03 -0800]:

> Bluetooth output the MAC address in reverse order.
> Bluetooth memory order: 00 01 02 03 04 05 is output "05:04:03:02:01:00".
> 
> This can save overall text when bluetooth is compiled in.
> 
> Bluetooth currently uses a very slightly unsafe local function (batostr)
> to output these formatted addresses.
> 
> Adding %pMbt allows the batostr function to be removed.
> 
> For x86:
> 
> $ size lib/vsprintf*.o*
>    text	   data	    bss	    dec	    hex	filename
>    8189	      0	      2	   8191	   1fff	lib/vsprintf.o.defconfig.new
>    8150	      0	      2	   8152	   1fd8	lib/vsprintf.o.defconfig.old
>   18633	     56	   3936	  22625	   5861	lib/vsprintf.o.allyesconfig.new
>   18571	     56	   3920	  22547	   5813	lib/vsprintf.o.allyesconfig.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Looks good to me.

Acked-by: Gustavo F. Padovan <padovan@profusion.mobi>

-- 
Gustavo F. Padovan
http://profusion.mobi
