Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0GZWPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:15:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63050 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab0GZWPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=wImAq2WV1mG01jyyE6hjWSg1mJHf0nNMQucv85C1hsfsZrf5gR4EhINeCLN4oLKiw6
         BMoX8KYARMgHyHxc4/+2DhhVe2yFISxA9/A4gWH+tMwEc+HDKLZ+LRoyQZbxi88opJUU
         /tj1yPhwjoKoLN8zDgZVcmKjez/Wa49AJtRrs=
MIME-Version: 1.0
In-Reply-To: <20100726212543.GA5424@srcf.ucam.org>
References: <AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com> 
	<1276870309.23783.3.camel@maxim-laptop> <1276933774.16697.11.camel@maxim-laptop> 
	<20100619123841.GA31838@hash.localnet> <1276952554.3332.3.camel@maxim-laptop> 
	<1276961564.5173.12.camel@maxim-laptop> <20100726201322.GI14855@tux> 
	<1280177362.3721.7.camel@maxim-laptop> <20100726210651.GJ14855@tux> 
	<1280179033.3721.15.camel@maxim-laptop> <20100726212543.GA5424@srcf.ucam.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Jul 2010 15:15:32 -0700
Message-ID: <AANLkTi=5_Dc8SumPi7cr8u7=DmnOHgSo6C76w9b0E4Kj@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v3] ath5k: disable ASPM
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
        "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        David Quan <David.Quan@atheros.com>,
        "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 2:25 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Jul 27, 2010 at 12:17:13AM +0300, Maxim Levitsky wrote:
>
>> However, it is possible, (and that what I asked you) that some ath5k
>> devices aren't 'pre 1.1 pcie devices' so linux won't disable ASPM L0s
>> for them.
>> So indeed for 'good feeling' it is ok to disable L0s from ath5k
>> explicitly, but most of the time (or always) it will be no-op.
>>
>> In *addition* to that, since you said that ASPM L1 *does* work, and is
>> enabled by BIOS, but linux disables it, that it might be worthy to
>> enable it again from ath5k driver explicitly.
>> As long as wireless works I don't really care if this done or not.
>
> This may need to be done on a chip by chip basis. Take a look at
> http://www.atheros.cz/inffile.php?inf=68&bit=32&atheros=AR5002G&system=4
> and some of the other inf files on that site to see which devices
> provide the PciASPMOptIn flag - those should support ASPM states even if
> they're pre-1.1 devices.

I rather we not bother with these, lets simply follow the kernel's
lead here for its rule matching.

  Luis
