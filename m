Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab1FJPw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 11:52:27 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:44758 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755305Ab1FJPw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 11:52:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=mIYvSS7usDp0fl8hbyGCi2zOTwVtApLDo+ui73Hk6ZukPwq7zefLr9zISf1GbCsZC4gnOLIF1jRWXrjWvs4645MVeiEq7xCJyjeiNa9bm0HfWE13ELnE/1iH9depTHdh;
Date: Fri, 10 Jun 2011 08:52:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] init: use KERNEL_DS when trying to start init process
Message-Id: <20110610085223.6aa97dee.rdunlap@xenotime.net>
In-Reply-To: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com>
	<1307642718-22257-1-git-send-email-minipli@googlemail.com>
	<20110609155630.0f734351.akpm@linux-foundation.org>
	<BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011 10:11:39 +0200 Mathias Krause wrote:

> cat<<EOT >hello.c
> #include <unistd.h>
> #include <stdio.h>
> 
> int main(void) {
>     printf("Hello %s world!\n", sizeof(int) == sizeof(long) ? "32" : "64");

             "Hello %s bit world!\n"

:)

>     pause();
> 
>     return 0;
> }
> EOT


> * If you're running a 64 bit kernel /etc/init should start and print
> out "Hello 64 bit world!", otherwise the kernel should fail to start
> this binary and go ahead to /bin/init.
> * Finally, if /etc/init failed, /bin/init should start and print out
> "Hello 32 bit world!".


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
