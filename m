Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab1FGPGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:06:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1FGPGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:06:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kDTbRk2FMWqFJH6EiIIVVVUgp2Dtv7LJQoSQsdoiunfa9YBOWI9B26IleW3BwNAoyA
         M3nrrm34UOqE8hshVoavP3d9ndF4L/YQmfprt9/EgNXJwzPZJbLfTBu4kmxpfGsFbIHa
         quBRiMqSJ/5uzRwfIu3dE7zlDvOH0FkzlVx20=
MIME-Version: 1.0
In-Reply-To: <20110607084349.GC4599@leaf>
References: <20110606011531.GA1887@leaf> <201106071011.15114.vda.linux@googlemail.com>
 <20110607084349.GC4599@leaf>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 7 Jun 2011 17:06:09 +0200
Message-ID: <BANLkTi=HBVt3_cD8Cw=0R5ZXGv-tYgHycQ@mail.gmail.com>
Subject: Re: Status of function-sections work?
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 10:43 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> On Tue, Jun 07, 2011 at 10:11:15AM +0200, Denys Vlasenko wrote:
>> On Monday 06 June 2011 03:15, Josh Triplett wrote:
>> > Hello,
>> >
>> > I found your work in 2010 on using function-sections and data-sections
>> > to eliminate unused code in the kernel.  I'd like to make use of this
>> > work to try to build an extremely space-constrained kernel.
>> >
>> > It looks like a few of your patches made it into the kernel, but most of
>> > the linker script changes don't seem to have made it in.  I wanted to
>> > find out the status of this work.  Do you still have this working?  Do
>> > you have versions of your patches for current Linux?
>>
>> parisc uses ^ in some identifiers. Therefore we need something like
>> [A-Za-z0-9_$^]* in linker script. This wasn't working with GNU ld -
>> ^ is not a valid char for pattern. Use of more general [!.]*
>> was also impossible - ! is not a valid char too.
>>
>> Therefore I asked binutils people to fix this (they agreed) and
>> decided to wait for a fixed binutils to be released.
>
> Makes sense.  Thanks for the explanation and status.
>
> Do you know if the fix has gone into binutils, either in a release or
> the latest snapshot from version control?  If not, does a patch exist?

Yes, latest released binutils has the fix.
-- 
vda
