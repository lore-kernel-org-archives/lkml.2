Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab1EHLZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 07:25:22 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42175 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab1EHLZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 07:25:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lYbpLa/rdU0bdV/pYcP9jWlTp0sZT0WUXAg/5mxT5RqXpkZpSKP51WoHv7Aj13qFz6
         5478pO6zN+uzkF/dGypsIR8opbpydmoH65bpNLru6JsdbRfhcbXQ7T6mpv4P//IDpcQv
         laieOxfgNAOih2iQO+pDwBz8m7QSVeCx53BC4=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=x76zkTpZxaHUnSUeP+_O0SsK0Zw@mail.gmail.com>
References: <BANLkTi=8U3=E0=j8MJ-r70O_aO8Pxvv9Nw@mail.gmail.com>
	<BANLkTi=F8u7oZM+=W+5vzmvf1b0YiN0fQg@mail.gmail.com>
	<20110420080535.3edd11ac@pluto.restena.lu>
	<20110420105631.70695dfa@lxorguk.ukuu.org.uk>
	<BANLkTikF5YL8tJ_f5510yy1Ywm69rOUK2A@mail.gmail.com>
	<BANLkTi=x76zkTpZxaHUnSUeP+_O0SsK0Zw@mail.gmail.com>
Date: Sun, 8 May 2011 19:25:18 +0800
Message-ID: <BANLkTiksbbCqnQG6N_xe69bvWSAA8AVAbQ@mail.gmail.com>
Subject: Re: [2.6.39-rc2, framebuffer] use after free oops
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: linux-fbdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>, Paul Mundt <lethal@linux-sh.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Anca Emanuel <anca.emanuel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2011 23:24, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> Hi, Daniel J Blueman.
>
> Did you test https://lkml.org/lkml/2011/5/5/208 ? And it works for you ?
> Then please reply with your error and an Tested-by.
>
> And CC: "Dave Airlie" <airlied@redhat.com>

Tested against 2.6.39-rc6. Instrumentation and debug catches the
(silent without debug) use-after-free case, which now doesn't show up
with this patch, so looks good. Probably good sense to get into
-stable too.

Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>

Thanks,
  Daniel
-- 
Daniel J Blueman
