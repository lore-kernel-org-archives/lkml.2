Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab1EaHZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 03:25:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52951 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1EaHZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 03:25:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZM4EWhI9LhDFSASdOzSSmvidflfoFILnPXZmbAKmfThu/FMu4bUOas8tmO+nGOa8j0
         OwjIfeEUuu4EbTyXkPJ6z5H+cojxJKIFkfZZqqYWM91xqtea9KGAyuOiEvDIiHKt1/Fr
         ngM/k4z+M5EaTYthXLKbfdTu7DNqkZ2QpiqAU=
MIME-Version: 1.0
In-Reply-To: <20110531054008.GA1906@mako-laptop>
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
	<BANLkTinsO2=tO_UyzzgeU6LE1fObgq+p1Q@mail.gmail.com>
	<20110530200329.GA1833@mako-laptop>
	<alpine.DEB.2.02.1105301545420.5766@asgard.lang.hm>
	<20110531054008.GA1906@mako-laptop>
Date: Tue, 31 May 2011 09:25:06 +0200
X-Google-Sender-Auth: L9IglTwFRo17HRHi3BQ7X_gC8LI
Message-ID: <BANLkTi=gEDrw1fkByVEhkqhQPAOTQU=R_w@mail.gmail.com>
Subject: Re: Linux 3.0-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mariusz Kozlowski <mk@lab.zgora.pl>
Cc: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 07:40, Mariusz Kozlowski <mk@lab.zgora.pl> wrote:
> On Mon, May 30, 2011 at 03:48:49PM -0700, david@lang.hm wrote:
>> >You could consider freezing linux-2.6.git repository and creating new
>> >linux-3.git repository that would serve for a couple of years until
>> >linux-4.git. At the same time development history could be dropped between
>> >trees so that inital clones are lighter. Anyone interested in history
>> >can download idx/pack from linux-2.6.git repo and attach it using gratf
>> >point[1] anyway.
>> >
>> >Pros:
>> >- obvious naming scheme wrt repository contents
>> >- smaller initial clone
>> >- new clean tag namespace
>> >
>> >Cons:
>> >- broken bisection for some time
>> >- impaired log/blame/whatchanged and friends
>>
>> in addition won't there be problems merging in work done on the old
>> tree? (since there would be no common history)
>
> Everyone would need to restart and probably reapply they changes on top
> of new tree (because of lack of common history).
>
>> everyone would need to re-clone their repository (and attaching
>> history wouldn't help this)
>>
>> there are probably others.
>>
>> frankly I don't see any real benifits from the Pros you list. the
>> initial clone is already rather small, it probably won't make that
>> big a difference to throw away several years of history.
>
> linux-2.6.git is all about lots of small changes so size isn't all that
> big today but there are quite many objects. Using grafts might help
> decreasing size of repository. I just mentioned it because it is a bit
> of a revolution time anyway and otherwise current tree will grow for next
> decade or so.

NAK. I regularly look into full-history-linux as linux-2.6.git doesn't
have enough
history for me. Please don't make it worse.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
