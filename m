Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab1DZTre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:47:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59343 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab1DZTrd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:47:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JIiSrz8gw3aM2FHLrSMUSvVZtOTvOug8U59Ya0HNgNF6P88a8brj/1/59CbcRX9ENk
         0ZHPvIUuRWbvCjaoy73JVslX3PamriXJRpN0yWKUCePakemyfuCbnyRpWqFrVHaDGEk2
         tWJOoykQSZcm/G8+NnRehUF/PYxgThp+STbFk=
MIME-Version: 1.0
In-Reply-To: <1303847110.24299.50.camel@Joe-Laptop>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	<20110426190531.GA4556@p183>
	<1303845468.18763.32.camel@gandalf.stny.rr.com>
	<20110426192029.GA4686@p183>
	<BANLkTinxvyxSK9f+kkQugNkQEBf1O65bLQ@mail.gmail.com>
	<1303846642.18763.37.camel@gandalf.stny.rr.com>
	<1303847110.24299.50.camel@Joe-Laptop>
Date: Tue, 26 Apr 2011 16:47:31 -0300
Message-ID: <BANLkTimf44AgMAViHrSEz78ifHUYb8ji6g@mail.gmail.com>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Thiago Farina <tfransosi@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 4:45 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2011-04-26 at 15:37 -0400, Steven Rostedt wrote:
>> On Tue, 2011-04-26 at 16:21 -0300, Thiago Farina wrote:
>> > On Tue, Apr 26, 2011 at 4:20 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> > > On Tue, Apr 26, 2011 at 03:17:48PM -0400, Steven Rostedt wrote:
>> > >> On Tue, 2011-04-26 at 22:05 +0300, Alexey Dobriyan wrote:
>> > >> > On Tue, Apr 26, 2011 at 03:49:49PM -0300, Thiago Farina wrote:
>> > >> > > + * streq - Are two strings equal?
>> > > The point is that function is trivial, and if someone doesn't
>> > > understand it, he should read some Kernighan and Ritchie first.
>> Replace it with something like:
>>       * Use this:     streq(a, b)
>>       * instead of:   strcmp(a, b) == 0 or !strcmp(a, b)
>>       * This makes the code more readable and less error prone.
>
> I think it's not good to introduce another form.
> strcmp is the standard everyone understands.
>
> There are already about 2800 uses of strcmp()==0 and !strcmp
>
> $ grep -rP --include=*.[ch] "\bstrcmp.*==\s*0\b" * | wc -l
> 1143
> $ grep -rP --include=*.[ch] "\!\s*strcmp\s*\(" *  | wc -l
> 1663
>
> Can you count how many misuses of strcmp have been
> corrected?

> Do you plan to convert the existing 2800?

I'd work on this without any problem.
