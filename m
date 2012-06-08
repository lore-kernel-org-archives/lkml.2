Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111Ab2FHQdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:33:49 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36143 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2FHQdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:33:47 -0400
Subject: Re: 3.5.0+ - Linus GIT - WARNING: at net/sched/sch_generic.c:255
 dev_watchdog+0xeb/0x15f()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wim Van Sebroeck <wim@iguana.be>, Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>, netdev <netdev@vger.kernel.org>,
        Huang Xiong <xiong@qca.qualcomm.com>
In-Reply-To: <CAHFgRy-u3Xh=1XjrZi2x+=6bBdQ=Ve8i6jer9ppjYEWun70hxQ@mail.gmail.com>
References: <CAHFgRy9jgxOrF=b=oQd-zK5CKxDacOKdBAX_BEuyW+R+sK_GyQ@mail.gmail.com>
	 <1339051157.26966.97.camel@edumazet-glaptop>
	 <CAHFgRy-u3Xh=1XjrZi2x+=6bBdQ=Ve8i6jer9ppjYEWun70hxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jun 2012 18:33:37 +0200
Message-ID: <1339173217.6001.129.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 12:26 -0400, Miles Lane wrote:

> I tested this patch as well and got the following (identical to the
> warning with the other patch you sent):

Is this card working on a previous kernel ?

If yes, you probably should do a bisection.



