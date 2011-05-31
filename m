Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab1EaHvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 03:51:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59714 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab1EaHvm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 03:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LvuPUGIvJvZyZ7WRfHJP5+Ky8byI7C31IVBKOiK1KpFgH1aKfR6dA4ND3lhJ5TL4m9
         uE9wQuTuNAkz8kKXFXk+oNM+UkdC8JMyRY8786nxUMPPI8C8KUkCzWNER05/AtTpAU6l
         A2gkauAEPcXEs2TIi6/qBq9Dnn9oP6WXzScGg=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=YE4fSVQTNaYAwZ1YijqsUfTRmHg@mail.gmail.com>
References: <1306006756-32009-1-git-send-email-geert@linux-m68k.org>
	<BANLkTi=YE4fSVQTNaYAwZ1YijqsUfTRmHg@mail.gmail.com>
Date: Tue, 31 May 2011 09:51:40 +0200
X-Google-Sender-Auth: ad0v1MjiAArLjlwL2MprB59GKYg
Message-ID: <BANLkTinm9uHHmRscV7w6y5WxGroGH0hSNQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] resources: Add lookup_resource()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-m68k@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 09:47, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> As I got two acks from David for the sparc bits and no objections, I
> queued these on my for-2.6.41 and for-next branches.

Did I really write that??? for-3.1, of course ;-)

Gr{oetje,eeting}s,

                        Geert (heading for coffee)

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
