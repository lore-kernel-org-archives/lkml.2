Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab0JQILp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 04:11:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65127 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab0JQILm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 04:11:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kV3P01KXbc23ZXNv/iEwXhj3qk5SustEn1GJA4zR+UEuJb/kaWDHBEwr1vpiHT6iQS
         OzJ6Dy2BKB6oqXHsQMbshg9CHSzcvd6Q2RRCpYyAybxf9/oVjUipzrQCxLjH/j03tvnm
         9IQlrest+uvme/LODq3UqFsK8HVuoTOEIiUvg=
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.2.00.1010171447020.319@localhost>
References: <1287250583-6856-1-git-send-email-justinmattock@gmail.com>
	<alpine.OSX.2.00.1010171418500.319@localhost>
	<AANLkTi=GzwULsPu4N11WAnarWWoiHPJvjqf+tppEfec9@mail.gmail.com>
	<alpine.OSX.2.00.1010171447020.319@localhost>
Date: Sun, 17 Oct 2010 10:11:41 +0200
X-Google-Sender-Auth: xQlLooi6kJzkHcBRMGc04Z0YDW8
Message-ID: <AANLkTinqoKds3H8TFSDhfnuq2SdnL8GpJ25rH4ie8qXX@mail.gmail.com>
Subject: Re: [RFC 1/2 v7]Update broken web addresses in the kernel.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Matt Turner <mattst88@gmail.com>,
        "Justin P. Mattock" <justinmattock@gmail.com>, trivial@kernel.org,
        jkosina@suse.cz, linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Frysinger <vapier.adi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 05:50, Finn Thain <fthain@telegraphics.com.au> wrote:
> On Sat, 16 Oct 2010, Matt Turner wrote:
>> On Sat, Oct 16, 2010 at 11:20 PM, Finn Thain <fthain@telegraphics.com.au> wrote:
>> > Looks good to me.
>> >
>> > Finn
>>
>> After this much back-and-forth, please give the poor guy your Reviewed-by tag.
>>
>
> I thought the reviewed-by tag was there to claim kudos for the reviewer.
>
> AFAIK, since I'm not a maintainer, I'm not in a position to offer any tag
> that's worth anything to Justin, like ack or sign-off.

I see no problem in you adding acked-by or reviewed-by tags here.

> (Regardles, I'm happy to see my reviewed-by tag on these.)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
