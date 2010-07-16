Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935089Ab0GPAml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 20:42:41 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65439 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934037Ab0GPAmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 20:42:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m5Xksl+oVTYlHZJ0Nj2PbrTrn8Dm4gLQxOr5EzIYHzHXtSvaQY7TZ4TaEgPFTc04/a
         MFAeD+r1ETpjSNUuXWZZO/Bd+7R3XaTf3XsZbCn7Vh+jj8Wv8UtJGkbSrinonedjvELO
         u9Ue649vmEse9uZ5ZEpEL3NNx52qcsCe4vt4U=
MIME-Version: 1.0
In-Reply-To: <20100714132434.GC3103@ucw.cz>
References: <1278026975.7738.89.camel@c-dwalke-linux.qualcomm.com>
	<AANLkTilGdNgWIprJ2XZ2gSv2d-DVybGmb9phcboi4fNL@mail.gmail.com>
	<1278029284.7738.116.camel@c-dwalke-linux.qualcomm.com>
	<AANLkTilEKPmHKNDNbNpmUvcYC338YezLkNBc4ShfTFdp@mail.gmail.com>
	<4C2D3066.9040104@codeaurora.org>
	<AANLkTilsqmCZwLUNJhvDKkralHQZzlRV3ZxaIGbt9-xB@mail.gmail.com>
	<AANLkTinvzJrx4AqgWYuMg66Djf-snouLQZE7wI9Bu0Kv@mail.gmail.com>
	<AANLkTimiNKRabIDCLvRwxVfdwuvt76PbDuTn2RocZLVG@mail.gmail.com>
	<1278038796.19705.21.camel@clockmaker-el6>
	<Pine.LNX.4.64.1007020456250.9535@bwv190.internetdsl.tpnet.pl>
	<20100714132434.GC3103@ucw.cz>
Date: Thu, 15 Jul 2010 20:42:39 -0400
Message-ID: <AANLkTikisB-m6ZrpXvToQm1P43S22U0tt9_E-sWETAz4@mail.gmail.com>
Subject: Re: Closed source userspace graphics drivers with an open source 
	kernel component
From: Tim HRM <zt.tmzt@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Piotr Gluszenia Slawinski <curious@bwv190.internetdsl.tpnet.pl>,
        Dave Airlie <airlied@redhat.com>, linux-arm-msm@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 9:24 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >There is no point supporting companies that give you a little bit of
>> >information in exchange they want the support that being in a mainline
>> >kernel gives. Its an unfair exchange of knowledge and time, and if they
>> >claim they have to make a profit then its even more unfair.
>>
>> also, they seem to do it quite wrong way. i.e. much simpler would be
>> to just implement regular, open driver , and implement additional
>> crypto
>> mechanism in chipset itself, allowing to use simple userspace program
>> sending certified keys allowing GPU to operate.
>
> What is going on there? Does msm actually use crypto to prevent you
> from use hardware you bought?
>
> Are the keys device-specific? What prevents me from
> reverse-engineering their binary and publishing them?
>                                                                     Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>

Hi Pavel. No I think that was meant to be theoretical/hypothetical.
There's no crypto or device key as such, this hardware is much like
any other that requires firmware to function.

I think the issue is broader than that. The question seems to be
whether an open API/ABI can be specified between an open kernel driver
and a closed userspace driver that is required to perform a subset of
the total functionality, in this case, certain GL and 3D primitives.
The other functions, 2d, the ability to bind a texture to a simple
poly, etc. can be potentially accomplished with an open source driver
and development of a radeonhd or avivo based driver in parallel.  But
that would require developers to agree on an API that can be stablised
and standardized between Android Xorg 2d driver and any potential 3d
driver, where the developers of closed source components must ensure
they remain compatible with whatever direction the open driver takes.

--
Timothy Meade
tmzt #htc-linux
