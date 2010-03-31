Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab0CaU54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 16:57:56 -0400
Received: from mail-pz0-f179.google.com ([209.85.222.179]:44416 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab0CaU5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 16:57:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GAEpG/v/lif5KCilPDuVf9AOSt8Kk34s4COjQIUtpld86LXJrdgpe29w/CO7lSrMsX
         gFEr6oCIU9srOj0J0HN1w2WwH4M4rxVdLZ97baah470Am6eaXSwdauqDVtkveoi/S0MR
         P5buHXVifZqj8VVcOf3WUf24cdlfCGJJF1/1w=
MIME-Version: 1.0
In-Reply-To: <20100331185916.GA12306@elte.hu>
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org>
	 <4BB2EB1B.8090303@zytor.com>
	 <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
	 <20100331185916.GA12306@elte.hu>
Date: Thu, 1 Apr 2010 06:57:53 +1000
Message-ID: <v2m21d7e9971003311357ga4626e41h535ae733933fdc84@mail.gmail.com>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
From: Dave Airlie <airlied@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       airlied@linux.ie, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 4:59 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * James Morris <jmorris@namei.org> wrote:
>
>> On Tue, 30 Mar 2010, H. Peter Anvin wrote:
>>
>> > On 03/30/2010 09:49 PM, James Morris wrote:
>> > >
>> > > Please make NO_BOOTMEM default to n, at least for amd64, where I've found
>> > > that it leads to all kinds of strange, undebuggable boot hangs and errors
>> > > (with relatively current Fedora development userland).
>> >
>> > Have you tested it with the latest fixes that are now in Linus' tree (-rc3)?
>>
>> Yes, it was happening with -rc3.
>
> Could you please send the bootlog that Yinghai asked for, plus also one that
> you get with NO_BOOTMEM turned off (for comparison)?
>
> Also, when did you first hit this bug? This code has been upstream for almost
> a month, and it was in linux-next before that - so you should have hit this
> much sooner. A rough timeframe would suffice. I suppose you were booting
> upstream kernels during the merge window as well?

A default y config option causing regressions still at rc3? and you guys
keep going? This is the sort of shit Linus would flame me for a day or two for,

Can we get some f'ing consistency here?

Dave.

>
> We can flip the default around if there's no fix available based on the
> bootlogs. (Plus the help text should definitely be improved.)
>
> Thanks,
>
>        Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
