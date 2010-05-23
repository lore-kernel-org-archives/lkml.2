Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab0EWVx3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 17:53:29 -0400
Received: from xenotime.net ([72.52.115.56]:55325 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751555Ab0EWVx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 17:53:27 -0400
Date: Sun, 23 May 2010 14:53:19 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: piotr@hosowicz.com
Cc: Jiri Slaby <jirislaby@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: What's up with wireless drivers?
Message-Id: <20100523145319.89008e2e.rdunlap@xenotime.net>
In-Reply-To: <4BF973E5.6050802@example.com>
References: <4BF6F2E4.5030800@example.com>
	<20100521210729.GC2495@tuxdriver.com>
	<4BF6F959.5040401@example.com>
	<4BF6FBB0.6060407@example.com>
	<20100521151203.f94c1d3e.rdunlap@xenotime.net>
	<4BF7073A.4090506@example.com>
	<4BF7986C.4030505@example.com>
	<4BF7D185.2040705@example.com>
	<4BF7D86B.3020204@example.com>
	<4BF7DDAA.1080307@gmail.com>
	<4BF7DEE7.9010801@example.com>
	<4BF7DFDA.3000604@gmail.com>
	<4BF7E470.6080409@example.com>
	<4BF7E769.1090102@gmail.com>
	<4BF93392.7010803@example.com>
	<4BF96B00.5060905@gmail.com>
	<4BF973E5.6050802@example.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 May 2010 20:28:53 +0200 Piotr Hosowicz wrote:

> On 23.05.2010 19:50, Jiri Slaby wrote:
> > On 05/23/2010 03:54 PM, Piotr Hosowicz wrote:
> >> And they had built flawlessly. But main build with make-kpkg
> >> kernel_image nevertheless still fails. I don;t know what to do. I don't
> >> want to do those strace's, because it will take awfully long.
> >
> > Why don't you just look at the actual error which is likely somewhere
> > above because of parallel build? And when you are posting outputs, first
> > switch your locale to en so that we can parse the output.
> 
> I tried again and the error is about CEPH. I attach the typescript. I am 
> totaly confused, now build breakse in yet another place than before.
> 
> Regards,
> 
> Piotr Hosowicz
> 
> PS: I ordered make modules without calling make first, I on't know if 
> it's ok.


  CC [M]  fs/ceph/msgpool.o
fs/ceph/msgpool.c: In function ___ceph_msgpool_put___:
fs/ceph/msgpool.c:173: error: implicit declaration of function ___kref_set___
make[2]: *** [fs/ceph/msgpool.o] B____d 1
make[1]: *** [fs/ceph] B____d 2
make: *** [fs] B____d 2


Known problem, but I haven't seen a fix for it yet.

And note how it says Error 1, not just Error 2.
Error 1 is the primary error.  Just showing us Error 2 is mostly useless.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
