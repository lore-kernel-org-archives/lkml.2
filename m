Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab2BISI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 13:08:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61040 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2BISI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 13:08:57 -0500
MIME-Version: 1.0
In-Reply-To: <8689.1328810841@redhat.com>
References: <20120209154819.32070.93358.stgit@warthog.procyon.org.uk>
 <1328804920.6099.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CA+55aFxHdFa4otDWJg4f+8sKEP3MBZqKBQCnH0Q8LXYtpdt1EA@mail.gmail.com>
 <CA+55aFyw1n=Bz3vi73RD5R13HyWLaVyPZc_z5rR7nGPzvs-BOw@mail.gmail.com>
 <7095.1328809567@redhat.com> <CA+55aFw5z85wuU8xJ_YFp0QB653yAGPOqeGXhJLbdj9ogpHqOA@mail.gmail.com>
 <8689.1328810841@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Feb 2012 10:08:36 -0800
X-Google-Sender-Auth: BOuQRT75Qt8uD_0XegfbOnSx-k8
Message-ID: <CA+55aFwxTe6+zng6OnK_oHBxwLsX+Z7wD45d=XLTGSL+6aoh9g@mail.gmail.com>
Subject: Re: [PATCH] Reduce the number of expensive division instructions done
 by _parse_integer()
To: David Howells <dhowells@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, adobriyan@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 10:07 AM, David Howells <dhowells@redhat.com> wrote:
>
> Do you want me to attach my patch description to your patch, or do you want to
> do that?

I'll commit it as yours and with your commentary, my changes were
purely cosmetic and just made the x86-64 inner loop look better.

                 Linus
