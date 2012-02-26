Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab2BZBxc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 20:53:32 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55705 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab2BZBxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 20:53:30 -0500
MIME-Version: 1.0
In-Reply-To: <4F498EFF.6040309@zytor.com>
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
 <20120221.221609.218135609185671883.davem@davemloft.net> <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
 <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
 <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com>
 <1329889428.2193.45.camel@perseus.themaw.net> <1329890027.2193.48.camel@perseus.themaw.net>
 <1329890251.2193.50.camel@perseus.themaw.net> <m2vcmuh8dg.fsf_-_@igel.home>
 <CA+55aFxH4_gucG7vpdV5NJPNHoXy5bSGtr0yHqmobvYO6PmjNw@mail.gmail.com> <4F498EFF.6040309@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Feb 2012 17:53:10 -0800
X-Google-Sender-Auth: 4mOLzl7I3v07bmKEiREsT7pRfXg
Message-ID: <CA+55aFxwZt3xwo6+KKCDYSXE78+uAVe49mZOyiO3n=ZOEa+Wxg@mail.gmail.com>
Subject: Re: [PATCH] autofs4: fix compilation without CONFIG_COMPAT
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Ian Kent <raven@themaw.net>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        autofs@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 5:46 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> I think this patch could help clean up other places, too.

Grepping for CONFIG_COMPAT shows that the most common test is for some
local variable that indicates "compatness".

The "is_compat_task()" test is actually surprisingly rare.

                    Linus
