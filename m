Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab2KBVnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 17:43:06 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35307 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2KBVnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 17:43:02 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <4911582.xWBr8PDhoE@vostro.rjw.lan>
References: <CA+55aFwwTc4QXKqiECgE9NOE2zjC6GsGHHydGP9YDbgQSbw9Aw@mail.gmail.com>
	<CA+55aFxm0D77c0RYJuAiq2EDJxn+hGKTEGYJnHXNM8XkVAYOTA@mail.gmail.com>
	<CAKMK7uEgnpTET0_VXWm7JyGePnXL-q_nHgSWq4g=qWodwrg38Q@mail.gmail.com>
	<4911582.xWBr8PDhoE@vostro.rjw.lan>
Date: Fri, 2 Nov 2012 22:43:02 +0100
Message-ID: <CAKMK7uENP_XWQ7UWjd+PnqTH-S-jYRjrnfY1TwocfbT6abL61w@mail.gmail.com>
Subject: Re: Linux 3.7-rc3
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 10:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Can you point me to a range of commits worth checking?

8c3f929b6147e142..57df2ae9df6e335a98969cac is the core rework (plus a
bit related follow-up) without any other merges interfering. Might
oops if you open/close the lid without a suspend/resume cycle (since
that's only fixed later on), should otherwise work.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
