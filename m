Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab0HCOsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 10:48:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39701 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab0HCOsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 10:48:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=PgWrZY6L9nrjJe8eO/lQhV/S5APhu15+zgflrgvkl7otZZbbBf+JganVJ5CTsSmnh/
         TrYOK41QkQIJT2yt9s3+HbBINAw9mh3fqT/3bEpzw9QVNiZASuwg24tI2tcEy/dV/ujg
         GtixRYpzJKtrgD6Q3pJV3YH3uGRsdcvYWn/ug=
MIME-Version: 1.0
Reply-To: dkirjanov@kernel.org
In-Reply-To: <201008030940.28831.rgetz@blackfin.uclinux.org>
References: <cover.1280447281.git.joe@perches.com>
	<AANLkTikYn+qpDxxLeJ4eu5SsEs=7n_wAu5RzM5pZhVwU@mail.gmail.com>
	<1280454323.21777.4.camel@Joe-Laptop.home>
	<201008030940.28831.rgetz@blackfin.uclinux.org>
Date: Tue, 3 Aug 2010 18:48:13 +0400
Message-ID: <AANLkTimKvr2ozzBFWcfbM88kV-i7i=Qh4pZsMsbWJZ_R@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] drivers/net/bfin_mac.c: Misc function 
	cleanups, neatening
From: Denis Kirjanov <kirjanov@gmail.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Joe Perches <joe@perches.com>, Mike Frysinger <vapier.adi@gmail.com>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 5:40 PM, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> On Thu 29 Jul 2010 21:45, Joe Perches pondered:
>> On Thu, 2010-07-29 at 20:18 -0400, Mike Frysinger wrote:
>> > i'll ack the idea, but i think it better i pull these patches into the
>> > Blackfin repo to get some real hardware testing before i forward them
>> > back to David/netdev ...
>> >
>> > that OK with you ?
>>
>> Fine by me.  These are trivial patches.
>> I don't have the hardware.
>
> Do you want the hardware?
>
> I'm moving my office, and found some extras if anyone wants them...

I can take one if that is no problem..

>
> -Robin
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards,
Denis
