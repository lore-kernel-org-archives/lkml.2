Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab0IDJBk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 05:01:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64848 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab0IDJBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 05:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GYHKLh81TaAWle5Lfl1GXzswtMm/0PSj7A5VJTf+ytKhZOLm6/q9Rh9f1UcYDO10Q1
         aDsZMGx/EdaiQCpn0w2eszKN25NWKKTQwhRXfK0zBsAv7ZQn2g2sPduh5NIWoTrHecz/
         iUwXjFQZo4ymyApXeRSiTc6rerbnU3GQXM2Es=
Subject: Re: Linux Kernel GDB tracepoint module 2010-8-30 release
From: Steven <mqyoung@gmail.com>
To: Hui Zhu <teawater@gmail.com>
Cc: "gdb@sourceware.org" <gdb@sourceware.org>, linux-kernel@vger.kernel.org,
        Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
In-Reply-To: <AANLkTi=o0HXcgEAhmyZRN7mVPys55Bc5CGncchSAKL6i@mail.gmail.com>
References: <AANLkTimjO7sBzR55XkPB7dmZvxXqc8PS4UDsgptXVt90@mail.gmail.com>
	 <1283504768.2100.43.camel@steven>
	 <AANLkTik=0wMHh9fg8_vK_Aor40J43mNojvfHadhHObKA@mail.gmail.com>
	 <AANLkTi=o0HXcgEAhmyZRN7mVPys55Bc5CGncchSAKL6i@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Sep 2010 17:01:31 +0800
Message-ID: <1283590891.1685.41.camel@steven>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hui,

Thank you verch much!
My board is 64-bit MIPS, is KGTP available on 64-bit MIPS?


Best Regards,
Steven


On Sat, 2010-09-04 at 15:47 +0800, Hui Zhu wrote:
> > The MIPS support that you interest is check in to the KGTP truck.  I
> > just try it with a mips32el board.
> > To cross-compile it, you need set the CROSS_COMPILE ,KERNELDIR and
> > ARCH in Makefile.
> 
> Forgot 1 thing, if you want remote debug the MIPS board, you can use
> call netcat in board for example:
> nc -l -p 1234 < /proc/gtp > /proc/gtp
> 
> And debug with GDB command:
> target remote board_ip:1234 

