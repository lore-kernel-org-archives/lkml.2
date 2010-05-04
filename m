Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab0EDCRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 22:17:47 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49414 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab0EDCRp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 22:17:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sLwPAgTgaNVYJnVsP4rFUSlJQkbyaqQRoL9YKDKQ0NkEk/Wa1GN6bjxT6lrvh8mPGb
         D9QBNZ5aXEzH2NlKhTNbIsSoxfw+fG3zMpCuYS7ghXfHy4yO1zBsnBnpc5nL4Dqrcr7s
         PN8Yt3OKUnAcawLm7RMoRB5JxxhB1XsVGs7jw=
MIME-Version: 1.0
In-Reply-To: <20100504004623.GT6684@trinity.fluff.org>
References: <cover.1269655208.git.joe@perches.com>
	 <0c97f736400ec243e71ba794ae7046a61d2449c1.1269655208.git.joe@perches.com>
	 <20100412194737.GS3048@n2100.arm.linux.org.uk>
	 <1271102450.2131.27.camel@Joe-Laptop.home>
	 <h2p9c9fda241004121653te938caa2u42e39c31f27e85e1@mail.gmail.com>
	 <1271126826.4631.7.camel@Joe-Laptop.home>
	 <p2y9c9fda241004161243p924e06f0rb1ff64d5ae258819@mail.gmail.com>
	 <20100504004623.GT6684@trinity.fluff.org>
Date: Tue, 4 May 2010 11:17:44 +0900
X-Google-Sender-Auth: 642b464e546d23e0
Message-ID: <q2m9c9fda241005031917gbe9236f3kd56bfdf9a76ae549@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: arch/arm/s3c and arch/arm/s5p
From: Kyungmin Park <kmpark@infradead.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux-arm@fluff.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org,
       Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 4, 2010 at 9:46 AM, Ben Dooks <ben-linux@fluff.org> wrote:
> On Sat, Apr 17, 2010 at 04:43:34AM +0900, Kyungmin Park wrote:
>> Please add me and marek.
>> Ben how do you think? Marek is proper person since he posted a lot of s5p
>> series patches.
>> Note that byoungho min is no longer works on this series
>
> I thought the System LSI group where wanting to maintain this, which is
> why I've been holding off making any comment about what is going on.
>
> Personally, I would like to see a co-maintainership between myself
> and whoever at Samsung before completely handing over the responsibility.

I agree. then how about the Marek, even though LSI want it. they don't
have enough experience with open source works. you can see the recent
their works at their git. but we are trying to modify and make a patch
with open source style.

Also we setup the public git for open source

Thank you,
Kyungmin Park

P.S., when do you expect to hand-over responsibility to others?
>
>> Thank you,
>> Kyungmin Park
>>
>> On Apr 12, 2010 7:47 PM, "Joe Perches" <joe@perches.com> wrote:
>>
>> On Tue, 2010-04-13 at 08:53 +0900, Kyungmin Park wrote:
>> > No, s5p stubs are maintained by Samsung.
>> >...
>> So perhaps you'll add yourself and the correct entries to MAINTAINERS?
>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
>
> --
> --
> Ben
>
> Q:      What's a light-year?
> A:      One-third less calories than a regular year.
>
>
