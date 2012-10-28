Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab2J1Pl3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 11:41:29 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35727 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab2J1Pl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 11:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUXKc03UrNiUaTmxeynAy1oDBDgVbjjDKcJor4vM+0P3w@mail.gmail.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-15-git-send-email-keescook@chromium.org>
	<CAMuHMdUXKc03UrNiUaTmxeynAy1oDBDgVbjjDKcJor4vM+0P3w@mail.gmail.com>
Date: Sun, 28 Oct 2012 08:41:27 -0700
X-Google-Sender-Auth: 3HBcJpVaTNa402wAIOzQtGGmKtY
Message-ID: <CAGXu5jLpM_qvP65rXgjC-UV7Hc=-Lg17jtv0=dVUGHYJ_jB+tQ@mail.gmail.com>
Subject: Re: [PATCH 014/193] arch/m68k: remove CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 2:18 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, Oct 23, 2012 at 10:01 PM, Kees Cook <keescook@chromium.org> wrote:
>> This config item has not carried much meaning for a while now and is
>> almost always enabled by default. As agreed during the Linux kernel
>> summit, remove it.
>>
>> CC: Geert Uytterhoeven <geert@linux-m68k.org>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> Or do you want me to take this through the m68k tree?

Stephen Rothwell has mentioned he'd prefer maintainers take these
patches into their trees, but I'm happy to carry them in mine if you
want to avoid the hassle. I'm doing this for several areas already.
It's up to you, but just let me know so I can either drop it from my
tree or move it to my linux-next tree. :)

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
