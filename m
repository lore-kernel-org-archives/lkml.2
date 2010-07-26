Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab0GZFDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 01:03:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33535
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386Ab0GZFDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 01:03:31 -0400
Date: Sun, 25 Jul 2010 22:03:48 -0700 (PDT)
Message-Id: <20100725.220348.48497105.davem@davemloft.net>
To: joe@perches.com
Cc: ron.mercer@qlogic.com, linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] drivers/net/qla3xxx.c: Checkpatch cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <118c687d97762e235ba61733ef1610f6443ae1eb.1279848705.git.joe@perches.com>
References: <118c687d97762e235ba61733ef1610f6443ae1eb.1279848705.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 22 Jul 2010 18:36:17 -0700

> Remove typedefs
> Indentation and spacing
> Use a temporary for a very long pointer variable
> More 80 column compatible
> Convert a switch to if/else if
> 
> Compile tested only, depends on patch "Update logging message style"
> 
> (old)
> $ scripts/checkpatch.pl -f drivers/net/qla3xxx.c | grep "^total:"
> total: 209 errors, 82 warnings, 3995 lines checked
> 
> (new)
> $ scripts/checkpatch.pl -f drivers/net/qla3xxx.c | grep "^total:"
> total: 2 errors, 0 warnings, 3970 lines checked
> 
> $ size drivers/net/qla3xxx.o.*
>    text	   data	    bss	    dec	    hex	filename
>   50413     212   13864   64489    fbe9 drivers/net/qla3xxx.o.old
>   49959	    212	  13728	  63899	   f99b	drivers/net/qla3xxx.o.new
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Also applied, thanks Joe.
