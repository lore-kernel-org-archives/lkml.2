Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab1FJTko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 15:40:44 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45789 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab1FJTkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 15:40:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=M0e2lix1Tt82uAYDkbJ70aAaJLiy9p30xrBC4j2gnczYgBw1MKBfnBwE0qr4bDmzU+
         05TG+ok4kNGZdQXY1YHY8Cu9L/8FdKfPE7IKMy3j00odnqEzodHgOp/MjwryMp6vtrdu
         xoVm+rr+SK0ayOQowK8dcgvmR00zcX8Kyb6O4=
MIME-Version: 1.0
Date: Sat, 11 Jun 2011 04:40:41 +0900
Message-ID: <BANLkTikjsw6QK99CxxrGh7HeospLrqMfcA@mail.gmail.com>
Subject: Reserving specific physical memory and mapping it to virtual memory
From: Jongman Heo <jongman.heo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I have a physical memory area, which is reserved by bootloader. Its
size is less than a page size (4kB).
The area will be reserved in order not to be used from Linux side, by
using memmap= boot arguments.

What I want to do is that reserving a virtual memory (one page) at
boot time, as well. (may need kernel modification?)
And copying the data of physical memory above to the reserved virtual memory.

Then, certain user space program can access to the memory, using the
address it already knows, which is physical.

I know that mmap() can do the memory translation thing, but we have a
limitation to use such kind of method.

Does anyboy know the solution?

Thanks in advance.

Regards,
Jongman.
