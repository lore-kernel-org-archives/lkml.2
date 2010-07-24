Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0GXJwt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 05:52:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53100 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0GXJws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 05:52:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tO3dzl9E6BFfKim9t8aSWdovz7SN1kPzAE04lTNMBxcUTwchYhk1VvUfQeiCPW3gjw
         v/oOVlhBjDS1creeLNX3f/xYA5WzXlxG3zXf91TNDPFjg0GmvE7Wm0NJgFcfsqe06pLl
         jum+iLnZw/WZrB1uJ7QBCkJR0KvsqugVl3oOI=
MIME-Version: 1.0
In-Reply-To: <AANLkTinxNlCSBqBggTIlVqyyn4NLy4LbZU8SFAlqPLow@mail.gmail.com>
References: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com>
	<AANLkTinxNlCSBqBggTIlVqyyn4NLy4LbZU8SFAlqPLow@mail.gmail.com>
Date: Sat, 24 Jul 2010 11:52:47 +0200
Message-ID: <AANLkTi=PkFZTuEujN4X8hJR-5YZf1Kz=9DW-XUFrPY0m@mail.gmail.com>
Subject: Re: Introducing the LCD-Linux project
From: Mattia Jona-Lasinio <mattia.jona@gmail.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <triad@df.lth.se>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>, ivan.kuten@promwad.com,
        lcd-linux-users@lists.sourceforge.net,
        Viktar Palstsiuk <viktar.palstsiuk@promwad.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 9:19 PM, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
> Someone told me once ago, when I submitted the cfag12864b/ks0108
> drivers, to make them use a framebuffer, so we could get a console on
> it using a program like con2fb program in an independent manner. It
> worked flawlessly and the console was quite usable!
>
> I see that you want to implement something more complex, but maybe
> someone/you can make a use of that idea. Check it out : )

Hi,

thanks for pointing this out. I'll certainly check it! :)

Regards,

Mattia
