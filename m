Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab0FVQtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:49:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43256 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab0FVQtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:49:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=U6yl+A0t6EImS7NCi296nJVdcgEdTWybN+LxoQqExx5oPozgdK0Fo7Q0zOhf4oJhld
         5YOXKyeaFX/GhzxNl90vp1Q3lWft7h7VqLmL+9jFhKvdLAiX7Wwke3yVroh8IRDnC9v7
         mz2DvCDpeqX/TwPDDNmW819Rvy9GLOiEOeNXg=
MIME-Version: 1.0
In-Reply-To: <20100622163138.GD20668@srcf.ucam.org>
References: <1276859156.19554.2.camel@maxim-laptop> <AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com> 
	<1276870309.23783.3.camel@maxim-laptop> <1276933774.16697.11.camel@maxim-laptop> 
	<AANLkTimIjaxq7IDWwIl1vv93k9bNQ2i89Sb5R5TiJmmA@mail.gmail.com> 
	<1277032723.9555.12.camel@maxim-laptop> <AANLkTim8iZmm8pEERJUsrQWOiLSjPUfCN-TFFzZZQWx2@mail.gmail.com> 
	<1277151410.5409.33.camel@maxim-laptop> <20100621233333.21262abjfxl8j1xc@hayate.sektori.org> 
	<AANLkTikkt4dqYWrwtTCJ8tJZLB1kZXgF1KvaPsIOO3Dl@mail.gmail.com> 
	<20100622163138.GD20668@srcf.ucam.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 22 Jun 2010 09:48:40 -0700
Message-ID: <AANLkTikQkLFdpusfcLVOpyZHFrxwB5akr-ggFB7Fjm08@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
To: Matthew Garrett <mjg@redhat.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       David Quan <David.Quan@atheros.com>, Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 9:31 AM, Matthew Garrett <mjg@redhat.com> wrote:
> On Mon, Jun 21, 2010 at 01:39:07PM -0700, Luis R. Rodriguez wrote:
>> Last I reviewed CONFIG_PCIEASPM won't buy you *anything* other than
>> debugging knobs. With it you can force all devices to enable ASPM
>> completely on or disable it. Both of which I think are not really
>> useful and instead should be done in userspace given that if you are
>> testing ASPM you likely want to test only one one device and its
>> respective root complex, not all at the same time.
>
> It buys you enabling of ASPM on devices that the BIOS hasn't configured,
> which is legitimate and useful.

Sure, I agree with that, but it also will enable ASPM for *all*
devices which have the capability which IMHO is a terrible idea for
users when all they want to do is enable ASPM for one device. Instead
I recommend users to enable ASPM for their devices selectively and
from userspace.

  Luis
