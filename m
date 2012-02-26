Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab2BZDIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 22:08:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39473 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab2BZDIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 22:08:41 -0500
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com> <20120221.221609.218135609185671883.davem@davemloft.net> <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com> <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com> <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com> <1329889428.2193.45.camel@perseus.themaw.net> <1329890027.2193.48.camel@perseus.themaw.net> <1329890251.2193.50.camel@perseus.themaw.net> <m2vcmuh8dg.fsf_-_@igel.home> <CA+55aFxH4_gucG7vpdV5NJPNHoXy5bSGtr0yHqmobvYO6PmjNw@mail.gmail.com> <4F498EFF.6040309@zytor.com> <CA+55aFxwZt3xwo6+KKCDYSXE78+uAVe49mZOyiO3n=ZOEa+Wxg@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+55aFxwZt3xwo6+KKCDYSXE78+uAVe49mZOyiO3n=ZOEa+Wxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] autofs4: fix compilation without CONFIG_COMPAT
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 25 Feb 2012 19:07:57 -0800
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andreas Schwab <schwab@linux-m68k.org>, Ian Kent <raven@themaw.net>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        autofs@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Message-ID: <50f96318-3d2f-4a76-b605-68be601d926b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fortunately it is, because it always indicates a major design facepalm.



Linus Torvalds <torvalds@linux-foundation.org> wrote:

>On Sat, Feb 25, 2012 at 5:46 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> I think this patch could help clean up other places, too.
>
>Grepping for CONFIG_COMPAT shows that the most common test is for some
>local variable that indicates "compatness".
>
>The "is_compat_task()" test is actually surprisingly rare.
>
>                    Linus

-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
