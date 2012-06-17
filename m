Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab2FQKNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 06:13:12 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35410 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab2FQKNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 06:13:08 -0400
MIME-Version: 1.0
In-Reply-To: <4FDC6874.4070106@afaics.de>
References: <4FDC6874.4070106@afaics.de>
Date: Sun, 17 Jun 2012 12:13:06 +0200
Message-ID: <CAFLxGvxpXBgOH=rhNUdE2FN=mm90sX4-Atwc4k-VrSxoAVZh9A@mail.gmail.com>
Subject: Re: wishlist: vnc framebuffer device?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Harald Dunkel <harri@afaics.de>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-console@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 1:05 PM, Harald Dunkel <harri@afaics.de> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi folks,
>
> To make a headless system "less headless", would it be possible
> to integrate a vnc framebuffer device into the kernel?

What about a VNC server which exports a framebuffer device?
Like: http://code.google.com/p/android-vnc

No need to implement VNC in kernel space.

-- 
Thanks,
//richard
