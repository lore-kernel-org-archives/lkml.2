Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0DSIOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 04:14:22 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:48861 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab0DSIOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 04:14:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=qt1bRUN1I5Je/zPf+JuE+4xKJ5n51AQYZ8EvBrgCeNX33zeGZ7Vx2TmMwHpdEV1h6q
         j4Iv+N5B1Jr84NkmxQSq5xLV8T79ncFw56maN3N/E26r3wt5ZXPL4gSmElezmoDtjhs/
         kZ7rwQqOrRpWEkPplPjjToyXG+SvtPkPjIUpw=
MIME-Version: 1.0
In-Reply-To: <4BCB373F.4070400@gmail.com>
References: <4BC9DB9A.9090605@gmail.com> <4BCAE9BC.3090609@gmail.com>
	 <4BCB373F.4070400@gmail.com>
Date: Mon, 19 Apr 2010 11:14:16 +0300
Message-ID: <m2s5e9821061004190114k63b8c00cu969cf1d1a0113196@mail.gmail.com>
Subject: Re: Network activity after route changes
From: Oleg Kutkov <elenbert@gmail.com>
To: Matt <tank.en.mate@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank, but this does not help me. Maybe it really my bug.

2010/4/18 Matt <tank.en.mate@gmail.com>:
> On 18/04/10 12:15, Oleg Kutkov wrote:
>>
>> Hello.
>> I try to send and receive ethernet packets on very low level in my kernel
>> module.
>> When i change (add or delete entry) routin table (via route command) my
>> network is freeze for ~15 seconds and my application can't send and receive
>> any packets.
>> Is it normal or bug somewhere in my application?
>> Can i change this behavior of route system? Maybe change some timeouts, or
>> immediately flush route (rt_flush() ?) table?
>
> Depending on your routing configuration the change may be causing the
> problem. Have you tried flushing the route cache (as opposed to the main
> routing table)?
>
> # ip route flush table cache
>
> matt
>
