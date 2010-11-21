Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab0KUPfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 10:35:04 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35060 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab0KUPfC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 10:35:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=dktjwnOyLBGzvnS0KOKN294vHbjx9PPGzdy8JTXe0KiNxwk6ILNMEPjNZMcdfg2yzf
         KfbEqoFeVLRCE5yeRcZ57hNT4ZVlSDjmWWO06NV0wCQaVZnWeJIYDMn+dCORn8mRexRg
         EjfEOXPRn2LRqwjHtPqFpew2ZfUq8gRXi3xUI=
MIME-Version: 1.0
Date: Sun, 21 Nov 2010 17:35:01 +0200
X-Google-Sender-Auth: xo75_spMte954-h7AMWajIKaoqM
Message-ID: <AANLkTi=ej5guZ2R72=fqe5mciwjVeY5LkDL3Qx1W0GvA@mail.gmail.com>
Subject: [PROBLEM] WARNING: at kernel/exit.c:910 do_exit
From: Pekka Enberg <penberg@kernel.org>
To: oleg@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The following warning triggered on me while I was browsing the web:

  http://twitpic.com/38vxxg

[ Click on the "Rotate photo" button for landscape version. ]

It's

        WARN_ON(atomic_read(&tsk->fs_excl));

in do_exit(). There was a prior oops in __pipe_free_info() called in
sys_recvmsg() paths that unfortunately scrolled away. Does it ring a
bell to anyone? This is latest Linus' master from few hours ago. I've
been running 2.6.37-rc1 until today without any problems.

I'll let you know if it triggers again.

                        Pekka
