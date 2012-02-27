Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab2B0QZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:25:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36185 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab2B0QZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:25:23 -0500
MIME-Version: 1.0
In-Reply-To: <4F4BADD2.5020908@zytor.com>
References: <20120221.221609.218135609185671883.davem@davemloft.net>
 <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
 <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
 <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com>
 <1329889428.2193.45.camel@perseus.themaw.net> <1329890027.2193.48.camel@perseus.themaw.net>
 <1329890251.2193.50.camel@perseus.themaw.net> <m2vcmuh8dg.fsf_-_@igel.home>
 <CA+55aFxH4_gucG7vpdV5NJPNHoXy5bSGtr0yHqmobvYO6PmjNw@mail.gmail.com>
 <4F4B30D5.6050305@de.ibm.com> <20120227090951.GA2681@osiris.boeblingen.de.ibm.com>
 <4F4BADD2.5020908@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Feb 2012 08:25:02 -0800
X-Google-Sender-Auth: G9YC3tkF70LxWL7iPp7UhPNgXMc
Message-ID: <CA+55aFz+JW3w06hCOL7uoiZg1ZBGoNLWfHPu_g7OJ8L1LW3iaA@mail.gmail.com>
Subject: Re: [PATCH] autofs4: fix compilation without CONFIG_COMPAT
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Andreas Schwab <schwab@linux-m68k.org>, Ian Kent <raven@themaw.net>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        autofs@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 8:22 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> This patch would seem to be The Right Thing; the combination of this really
> takes what s390 has done in arch space and globalizes it.

Yeah, I already applied that s390 fixup and pushed it out. And yes,
the fact that s390 already did the whole "is_compat_task()" dance on
its own just shows that we should have done this in <linux/compat.h>
from the very beginning.

                  Linus
