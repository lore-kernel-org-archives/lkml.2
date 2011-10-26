Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1JZNSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:18:44 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40511 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab1JZNSn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:18:43 -0400
MIME-Version: 1.0
In-Reply-To: <20111026114236.GA22180@kroah.com>
References: <20111026114236.GA22180@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Oct 2011 15:18:21 +0200
X-Google-Sender-Auth: kQEsOcRCrMzWRb8hT7TZT5v9qTA
Message-ID: <CA+55aFycM+nHxJNnFSjEXQvZkeBfHu161ePC0=7sWKZR1toQNA@mail.gmail.com>
Subject: Re: [GIT PATCH] TTY/serial driver patches for 3.2
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 1:42 PM, Greg KH <gregkh@suse.de> wrote:
>
> The one in 8250_pci.c is trivial to fix, the atmel_serial one isn't as
> easy, but I'm sure you can figure it out :)  If you want me to do the
> merge for it, I'll be glad to do so, just let me know.

So I figured it out, but please double-check, especially since it
seems to be some arm-only driver that I can't even compile-test my
resolution.

                 Linus
