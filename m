Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab1CHUVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:21:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51309 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab1CHUVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:21:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eyq2T0Fd2ZzM30MOKt73ZkYXqzteV+hAZnZj+3y5+WqusPeTQ/0Pv8qtp32XO9kZQE
         jsYlIbJcIgAsbuyBIc+KrWxS5GM9gAKGFyvmUMzt0wCzHpcioBPh5tYQ6SHbniXPSA2i
         kNFce5bqvTXeRV1T6HcWDifvHRPr0tRI7IUd8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1103081913560.2968@kaball-desktop>
References: <alpine.DEB.2.00.1103011517280.2917@kaball-desktop>
	<4D6D6980.7060304@kernel.org>
	<alpine.DEB.2.00.1103071527500.2968@kaball-desktop>
	<AANLkTi=aUGdjvtvy81FimMZB5PZNzASXHN0BZHWHUuLs@mail.gmail.com>
	<alpine.DEB.2.00.1103081203260.2968@kaball-desktop>
	<AANLkTikmiKvdgzE_G1-w7PBqBf=kD5R5k5QZChHeiDCd@mail.gmail.com>
	<alpine.DEB.2.00.1103081728300.2968@kaball-desktop>
	<AANLkTinkA5UNfdAqhnJYgC+czPrNYtOtfY332JCvZXy-@mail.gmail.com>
	<alpine.DEB.2.00.1103081913560.2968@kaball-desktop>
Date: Tue, 8 Mar 2011 12:21:51 -0800
X-Google-Sender-Auth: axlV1r8OE3lxcx7Fw3YLFh9XFn0
Message-ID: <AANLkTimq_cqZ7xgLcx5ch_GQS5gxQse5gVqpaTYRXh_x@mail.gmail.com>
Subject: Re: "x86-64, mm: Put early page table high" causes crash on Xen
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 12:09 PM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> On Tue, 8 Mar 2011, Yinghai Lu wrote:
>> [    0.000000] kernel direct mapping tables up to 7f750000 @
>> [0x7f74c000-0x7f74ffff] pre-allocated
>> [    0.000000] DEBUG map_low_page phys    243a000
>> [    0.000000] DEBUG map_low_page phys    243e000
>> [    0.000000] DEBUG alloc_low_page phys   7f74c000
>> [    0.000000] DEBUG map_low_page phys    243a000
>> [    0.000000] DEBUG map_low_page phys   7f74c000
>> [    0.000000] DEBUG alloc_low_page phys   7f74d000
>>
>
> I couldn't see this on my machine but I was afraid it could happen on
> some hardware :(

if system have more than 4g memory.

> Thank you very much for spending your time on this and for your kind
> replies.
> I'll follow up with an update of the xen specific patch I posted before
> and I won't bother you again with this :)

never mind.

Thanks

Yinghai
