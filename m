Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab0KGVou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:44:50 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34345 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab0KGVot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:44:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=yIL124dWHjwX6757lVCXLUGQgDHr0GCpnU26qB6fn33aX7AxZNkZt4xpqVhZL85mqc
         yyYxrq8sR0yM4zZn6PNtuyubk8ZijE0uQmt8IFUDIyOGRah4/rq2nBzXcG4nplT2RBZm
         PcwNI8WTx4Em5av5TCX7qw2445/LdeHJWqP6Y=
MIME-Version: 1.0
In-Reply-To: <20101107155757.GA13736@kroah.com>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
	<AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
	<20101106181202.GA6927@kroah.com>
	<39580686-A899-4689-BAAD-AF5546B34E49@mac.com>
	<AANLkTimVsUsrmTvsHqFiqJh1hhryMBemGyW+kYLKGgEu@mail.gmail.com>
	<20101107155757.GA13736@kroah.com>
Date: Sun, 7 Nov 2010 16:44:48 -0500
Message-ID: <AANLkTik=UWwRLOaHMfVifYiQPpSwoYuA6J1EoL5BOgJY@mail.gmail.com>
Subject: Re: Forked android kernel development from linux kernel mainline
From: Arnaud Lacombe <lacombar@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Anca Emanuel <anca.emanuel@gmail.com>, Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Nov 7, 2010 at 10:57 AM, Greg KH <greg@kroah.com> wrote:
> [...]
>
Just a small comment to say that Android is not the only one (but
certainly the most visible, and thus easiest to bash on) not making
effort to get their stuff in mainline. OpenWRT people are also
maintaining their fork of the kernel, without even using git, and not
contributing much to mainline (I'm certainly mistaken on that last
comment).

I'm still stuck to use their 2.6.32 to use my AR71xx-based (MIPS)
boards, just this part is +15kloc.

 - Arnaud
