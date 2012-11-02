Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab2KBVwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 17:52:18 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53178 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757073Ab2KBVwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 17:52:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>
Subject: Re: Linux 3.7-rc3
Date: Fri, 02 Nov 2012 22:56:22 +0100
Message-ID: <1490901.1Nt8OOcfdR@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAKMK7uENP_XWQ7UWjd+PnqTH-S-jYRjrnfY1TwocfbT6abL61w@mail.gmail.com>
References: <CA+55aFwwTc4QXKqiECgE9NOE2zjC6GsGHHydGP9YDbgQSbw9Aw@mail.gmail.com> <4911582.xWBr8PDhoE@vostro.rjw.lan> <CAKMK7uENP_XWQ7UWjd+PnqTH-S-jYRjrnfY1TwocfbT6abL61w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 02, 2012 10:43:02 PM Daniel Vetter wrote:
> On Fri, Nov 2, 2012 at 10:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Can you point me to a range of commits worth checking?
> 
> 8c3f929b6147e142..57df2ae9df6e335a98969cac is the core rework (plus a
> bit related follow-up) without any other merges interfering. Might
> oops if you open/close the lid without a suspend/resume cycle (since
> that's only fixed later on), should otherwise work.

Well, as it turns out, v3.6.0 doesn't work too with my .config, so never
mind (and thanks for help :-)).

I wonder what's wrong with my .config, though ...

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
