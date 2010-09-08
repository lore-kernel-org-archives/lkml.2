Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab0IHWOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 18:14:18 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49361 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab0IHWOM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 18:14:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C4q0kRys0kTTiUp4NksAOAJfe+kwKuxkW8qYGUFGek3935pvgzS6bi9ASF5quGbLpq
         annkaNhDpKrPrUb+20IxbcpP3jLAOzZp0utueUrFKdYXAPQKq+1jqMPnZJi/XNI5ohEt
         odw+QwPSqdVezhrKDEqmWo5aO5VCEH5QaXa1U=
MIME-Version: 1.0
In-Reply-To: <4C880278.3060108@zytor.com>
References: <AANLkTimqn6=uzE9FawJkWe3w3+AipiMUUcjLd8fo48s1@mail.gmail.com>
	<AANLkTim0GX8bmZu8j5wVs11QFCmKjNK2MBkV7Mcha_Ae@mail.gmail.com>
	<4C880278.3060108@zytor.com>
Date: Wed, 8 Sep 2010 23:14:11 +0100
Message-ID: <AANLkTimp5kh3Wg5kzfCWq0Rz3uCL7ivu+TED1oHcFDP8@mail.gmail.com>
Subject: Re: Promoting Crusoe and Geode Processors to i686 Status
From: Nick Lowe <nick.lowe@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here goes...

-mtune tunes the binary for given architecture. This as opposed to
defining the baseline architecture, and thus available instruction
set, which -march does.

I believe that -mtune is predominantly used for instruction
scheduling. GCC uses it when it's reordering instructions to optimise
for specific micro-architecture over others.

With -mtune=i686, I am of the opinion that you instruct the compiler,
and give it the opportunity, to deliver a better ordering of the
instructions. In this case, better ordering for i686 than you would
get with -mtune=generic32.

I'm probably wrong somehow, it's probably marginal, and I'll concede
to your infinitely better knowledge any day! That's why I phrased it
as a question! :)

Cheers,

Nick

On Wed, Sep 8, 2010 at 10:39 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 09/07/2010 05:27 PM, Nick Lowe wrote:
>>
>> 2) Should there be the special case that forces the suboptimal
>> -mtune=generic32 to work around the binutils NOPL bug or, as I think,
>> should people just update to a sane binutils version? (It's a special
>> case triggered where CONFIG_X86_P6_NOP is not set.)
>>
>
> What's suboptimal about it?
>
>        -hpa
>
