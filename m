Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab0DCSOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 14:14:33 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:47520 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab0DCSO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 14:14:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=qgRgPfINF9eT2EUwIWWYTQP6d4bnnVjOX9Sc+VzbWLbMOf66AGgJJTpBESs/C6IbIZ
         WteukRDRLA6ag/PtILu0JYkxj1dgCM5MT/7IKa36MiOZJf6dokDhZs7UBl8ZAn6Dl3Ez
         FXgyQGPeENL+9AN2VUQn/WdIVtsTwKh3Xs9NE=
MIME-Version: 1.0
Date: Sat, 3 Apr 2010 23:44:26 +0530
Message-ID: <r2if22d86811004031114p3057035et294dc5b3977b462d@mail.gmail.com>
Subject: Ptrace : reading process user area, stack size etc
From: "Leonidas ." <leonidas137@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am trying to read the stack size from user area for processes which
I am ptracing, for some reason
the stack is being reported as ffffffff.

This is how I am trying read the stack size, using struct user from
sys/user.h, I am on x86,

stack_size = ptrace (PTRACE_PEEKUSER, getpid(), offsetof (struct user,
u_ssize), 0);


Any idea? What is the best way to read stack size of each thread? I
know getrlimit() but that just talks about
size of main thread. Each thread on my system can have different stack
size and I cant use pthread_* functions
here.


-Leo.
