Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab1AFI7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:59:16 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57504 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1AFI7P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:59:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xqKOTasTxdQtC2kQO0fKsZadeuFzcsk7t57cD20ag/+Vkeo7w/iv7yb9esb9SWPlmu
         nKlX3iYhgxg3bICzkwA8IrPmi5f1B7l6EziiV0bK4UuA9B6dBQkJVWLXz/3ZY5Bgp41M
         u2tClVNJOyKJl9+1FXJR20HTZHHe+MN3pClyw=
MIME-Version: 1.0
In-Reply-To: <4D257DEE.40009@evidence.eu.com>
References: <18536664.253751287691209904.JavaMail.root@mail-zbox20.bo3.lycos.com>
	<28654042.253821287691362834.JavaMail.root@mail-zbox20.bo3.lycos.com>
	<4D257DEE.40009@evidence.eu.com>
Date: Thu, 6 Jan 2011 09:59:13 +0100
X-Google-Sender-Auth: jk6_mZdGz0zjzfo43k-V8nyly6Y
Message-ID: <AANLkTik_pa7ac4iQAyU7JeUej7qfkAvYQTru7n0-mZAt@mail.gmail.com>
Subject: Re: On Linux numbering scheme
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 09:31, Claudio Scordino <claudio@evidence.eu.com> wrote:
>>   As time passes by, the Linux numbering scheme makes even less sense.
>>   Some time ago there was a discussion on LKML about a new numbering
>>   scheme but it didn't come to any positive conclusion and then the
>>   subject was forgotten entirely. Not meaning to raise a clamour here
>>   (and I suppose I represent a large group of Linux users here). I'm
>>   willing to suggest a numbering scheme which I hope will answer all
>>   known complaints and criticism.
>
> This seems to be a periodically recurrent topic on the list.
>
> If I've correctly understood all points of view, there are currently two
> groups of developers:
>
> 1. Those who want to maintain the current numbering scheme, because they
> feel comfortable with it, and because they can easily understand the
> number of releases between one release and another.
>
> 2. Those who prefer having a scheme somehow related to the date, so they
> can easily understand when a certain kernel has been released (i.e. how
> "old" it is).
>
> Does really exist a numbering scheme that can satisfy both groups of
> people ? Probably not.
>
> My only idea would be to maintain the usual numbering scheme, and just
> replace the second number (6) with the year of release.
>
> For example:
>
>        2.6.36 would be 2.10.36
>
>        2.6.37 would be 2.11.37
>
>        2.6.38 would be 2.11.38
>
>        and so on...
>
> This way, you put some information about the year of release without
> loosing all the benefits of the current scheme.
>
> But this means having two independent incremental numbers, which maybe
> is a too insane scheme.

Then why not drop the leading "2." completely?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
