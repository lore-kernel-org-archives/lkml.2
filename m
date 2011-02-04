Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab1BDQzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 11:55:43 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53532 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab1BDQzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 11:55:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=AE9pQiRgl4ImZFRkeMgfE4ddeHHbOpxe2wwQRs/q0liO531ygWD7mQjEV/VSz0IbKj
         2PBEDsYxPrrMAYNv6N+DcGY0a8v8LLnO8VKn+DBRE4k1oooFHHd4l9ycU6TnIGqTXoXT
         os9X1/1dOjIS25RDz8+0cRXxd4/qr4vRn3uz0=
MIME-Version: 1.0
Date: Fri, 4 Feb 2011 16:55:40 +0000
Message-ID: <AANLkTimBFBKJf0-TNRLr2hHNEehR2cnKPvx06=yyHGVj@mail.gmail.com>
Subject: Re: Sun GEM PPC32 Bug?
From: Matt <jackdachef@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "R. Herbst" <ruediger.herbst@googlemail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I myself don't have any PPC32 box but I just googled some of the
keywords Ruediger posted "gem eth0: RX MAC fifooverflow smac"

and there were even similar or related messages going back to 2004
(and kernel 2.6.9).

Slab corruption seems to be involved (in some ?) cases (e.g.
http://www.mail-archive.com/netdev@vger.kernel.org/msg08345.html)

so it sounds serious to me (from an users point of view).

A kind of temporary fix seems to rmmod and modprobe the kernel-module,
according to:http://ubuntuforums.org/showthread.php?t=1428330


For the German speaking folks there's a thread over at
forums.gentoo.org (http://forums.gentoo.org/viewtopic-t-862767.html)

and 2 additional English threads which might provide additional info
on this (and another sound) issue:

http://forums.gentoo.org/viewtopic-t-862229.html "kernel: eth0: RX MAC
fifo overflow smac"

http://forums.gentoo.org/viewtopic-t-862579.html "Soundissue extreme quietly"

I'm not subscribed to the list so please CC

Thanks & Regards

Matt
