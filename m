Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab1EACyt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 22:54:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941Ab1EACys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 22:54:48 -0400
MIME-Version: 1.0
In-Reply-To: <web-516109980@zbackend1.aha.ru>
References: <web-515866242@zbackend1.aha.ru> <BANLkTimfOCwZQP=Hv+NEhFcxMpC51-RhTw@mail.gmail.com>
 <BANLkTinv38NtVQHrayus6v89BocsK6+iQQ@mail.gmail.com> <web-515897851@zbackend1.aha.ru>
 <BANLkTi==L3vDQ0jF9jP1hzhU-WmToBh=uA@mail.gmail.com> <20110430114332.GC29280@htj.dyndns.org>
 <4DBC09C7.9080205@fusionio.com> <BANLkTimGJiugYaXW8c77dspjADrF+m4VHA@mail.gmail.com>
 <web-516074613@zbackend1.aha.ru> <BANLkTin8wf0T9nD9zmdh=4-rmj6WCy86cA@mail.gmail.com>
 <web-516109980@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Apr 2011 19:53:57 -0700
Message-ID: <BANLkTi=POnnoNLy=iaubARMYG4L4CxEOLQ@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: werner <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, tj@kernel.org
Content-Type: text/plain; charset=KOI8-R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/30 werner <w.landgraf@ru.ru>:
>
> On the other hand, there occurs also ocasional crashs during booting in an
> earlier stage. See the 2nd foto anexed.

Oh, you have KMEMLEAK enabled too.

Disable it. It is very useful when looking for leaks and when it
works, but it often doesn't work, and just leads to problems.

                  Linus
