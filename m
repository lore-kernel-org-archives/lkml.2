Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2D3AZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 20:25:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38012 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab2D3AZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 20:25:57 -0400
MIME-Version: 1.0
In-Reply-To: <4F9DD994.70202@zytor.com>
References: <20120429205429.63CCD7C0064@ra.kernel.org> <4F9DD994.70202@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 Apr 2012 17:25:35 -0700
X-Google-Sender-Auth: SSeGqLeL5_osW_njBZU_9PRcPyg
Message-ID: <CA+55aFy72rPMq3M2_PU0ue45Fb38_Effrfhu2uOpdVXt9H1XOg@mail.gmail.com>
Subject: Re: autofs: make the autofsv5 packet file descriptor use a packetized pipe
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        autofs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 5:15 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> I just looked at am-utils; am-utils *does* use autofs v5, and *will*
> loop back and read more data on a short read.

Can you point to the sources?

If it's "short read" as in "I didn't get as much as I expected", that's fine.

If it is "short read" as in "I don't even try to read 300 bytes, I
read it in 8-byte chunks", we're screwed.

                     Linus
