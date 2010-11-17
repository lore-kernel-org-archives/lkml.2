Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935715Ab0KQXKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:10:07 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42987 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935648Ab0KQXKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:10:04 -0500
Date: Wed, 17 Nov 2010 15:09:31 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        <paulmck@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 17
Message-Id: <20101117150931.48cbd397.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTimKbxE6MQrp_pdgk-HAUxXU+iukFFPvFtsbP+DB@mail.gmail.com>
References: <20101117140956.a8264c75.sfr@canb.auug.org.au>
	<AANLkTimKbxE6MQrp_pdgk-HAUxXU+iukFFPvFtsbP+DB@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 23:53:14 +0100 Zimny Lech wrote:

[adding Paul McKenney]


> Salve!
> 
> 2010/11/17 Stephen Rothwell <sfr@canb.auug.org.au>:
> > Hi all,
> >
> > Changes since 20101116:
> 
> Might be something new
> 
>   CC      kernel/rcutiny.o
> In file included from /home/test/linux-2.6/kernel/rcutiny_plugin.h:264:0,
>                  from /home/test/linux-2.6/kernel/rcutiny.c:53:
> /home/test/linux-2.6/kernel/rtmutex_common.h: In function 'task_has_pi_waiters':
> /home/test/linux-2.6/kernel/rtmutex_common.h:81:29: error: 'struct
> task_struct' has no member named 'pi_waiters'
> /home/test/linux-2.6/kernel/rtmutex_common.h: In function 'task_top_pi_waiter':
> /home/test/linux-2.6/kernel/rtmutex_common.h:87:9: error: 'struct
> task_struct' has no member named 'pi_waiters'
> make[2]: *** [kernel/rcutiny.o] Error 1
> make[1]: *** [kernel] Error 2
> make: *** [sub-make] Error 2
> 
> 
> Probably know issue
>   CC      sound/oss/ad1848.o
> /home/test/linux-2.6/sound/oss/ad1848.c:2867:32: warning: 'id_table'
> defined but not used
>   CC      sound/oss/mpu401.o
> make[3]: *** No rule to make target `/etc/sound/trxpro.hex', needed by
> `sound/oss/trix_boot.h'.  Stop.
> make[2]: *** [sound/oss] Error 2
> make[1]: *** [sound] Error 2
> make: *** [sub-make] Error 2


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
