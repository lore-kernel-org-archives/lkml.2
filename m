Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab0HKOFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 10:05:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52977 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab0HKOFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 10:05:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MDSfTYGxQfzcwlEvRLZtbqAZNYvDvrxZ8Pmeq0t8BISWOgggE4uytVGy9AwcBYbDIq
         JHiYTLQZ1Nd8cVzEuW7dg3/ryv2R8Du9UffYuppw9NXkHbauNTSFsXM1LL9AOfohzKbp
         c6KDmH7b3xkdeQucmdsEEom2anniM96IAST2A=
MIME-Version: 1.0
In-Reply-To: <1281389338.7143.32.camel@localhost>
References: <4C5F9B25.8080401@st.com>
	<201008091735.11105.mihai.dontu@gmail.com>
	<4C6040FC.2020702@gmail.com>
	<201008092115.25992.mihai.dontu@gmail.com>
	<1281389338.7143.32.camel@localhost>
Date: Wed, 11 Aug 2010 16:05:40 +0200
X-Google-Sender-Auth: Vkx9YER83oK8PtlUbmnpd_JiePA
Message-ID: <AANLkTikQWj=Vx7T_+SjqRS3GTDgHQ6x2zn_MgcCUTj9M@mail.gmail.com>
Subject: Re: Query: Patches break with Microsoft exchange server.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: =?UTF-8?B?TWloYWkgRG9uyJt1?= <mihai.dontu@gmail.com>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        viresh kumar <viresh.kumar@st.com>,
        Matti Aarnio <matti.aarnio@zmailer.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 23:28, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2010-08-09 at 21:15 +0300, Mihai Donțu wrote:
>>
>> Wait. I don't think we're on the same page here. I'm talking about message
>> signing (which does not require the receiving end to have any key - it's the
>> same plain text e-mail with a blob after it) while you refer to actually
>> encrypting the message. Mm? Or am I being extremely slow today? :-)
>
> Only when you assume that Exchange would pass signed messages without
> corrupting them. It really is that broken.

Indeed. In my experience Exchange may
  - corrupt PGP signed email, causing the signature verification to fail,
  - send/forward all email in BASE64, causing it to be dropped by
vger.kernel.org.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
