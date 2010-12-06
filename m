Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0LFEyO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 23:54:14 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55183 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0LFEyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 23:54:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xeefX/8KmfktlgiQap8NfKI8enaEgVaF6M5Td9F/AWJT/IYY9KSotUR1OMoQjWxw0j
         zM/4NsjFngsv/M59fL7/sys1l6JMKcrDiWBm9Zm3Q0oM0J06ol/tpsyRYVFUB40djXa/
         gWBG4E13M1rCn+7KkXrNOPGN7E6mcpp6Ip99k=
MIME-Version: 1.0
In-Reply-To: <20101205165034.GA15738@kroah.com>
References: <20101203210719.GB21223@windriver.com>
	<20101204172840.GC10282@kroah.com>
	<20101205011644.GB314@windriver.com>
	<20101205165034.GA15738@kroah.com>
Date: Sun, 5 Dec 2010 23:54:12 -0500
Message-ID: <AANLkTimiCByVmWPcdVM5bcMacbWon88K+R6wYmHUbeXD@mail.gmail.com>
Subject: Re: Announcement: Plans for v2.6.34-longterm
From: Bruce Ashfield <bruce.ashfield@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org,
        jason.wessel@windriver.com, Andi Kleen <andi@firstfloor.org>,
        lwn@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 5, 2010 at 11:50 AM, Greg KH <greg@kroah.com> wrote:
> On Sat, Dec 04, 2010 at 08:16:44PM -0500, Paul Gortmaker wrote:
>> [Re: Announcement: Plans for v2.6.34-longterm] On 04/12/2010 (Sat 09:28) Greg KH wrote:
>>
>> > On Fri, Dec 03, 2010 at 04:07:19PM -0500, Paul Gortmaker wrote:
>> > > With that in mind, it is our intention to also maintain a 2.6.34
>> > > longterm tree.  Jason and I work at Wind River, which already has
>> > > released products based on v2.6.34, and as such it only makes sense
>> > > to have a public long-term tree that others who are also based on
>> > > 2.6.34 can make use of.
>> >
>> > Other than Wind River, what other distros/userbases are using .34 as a
>> > platform for their products?
>>
>> Well, since we create more of a distro builder, than a distro itself,
>> anyone who uses WR to in turn create a distro for their own hardware or
>> product will of course be using 2.6.34.  The Yocto project is currently
>> using the 2.6.34 kernel and I'm sure there are others I'm not
>> immediately aware of.
>
> I thought Yocto was going to be using .35, hence Andi and Tim's work to
> get that one "longterm"?

There was some slight confusion at the plumbers conference, but Paul
is correct, the kernel that accompanied yocto 0.9 was 2.6.34 based, and
we'll shortly (measured in days) also have a 2.6.37 tracking kernel.

>
> Anyway, that's fine, I was just curious, thanks.

Also fine with me, just thought I'd take the chance to clarify.

Cheers,

Bruce

>
>> > And how long do you expect to be maintaining this .34 branch for?
>>
>> The expectation is that maintenance will be ongoing for years, since
>> we'll largely be needing to do that work anyway.  I plan to follow your
>> lead on how you handled .27 -- i.e. the "early" releases will possibly
>> be rich with content, but as it gets to be closer to EOL (i.e. on the
>> order of 10 releases removed from current), then it will only be the key
>> CVE-like fixes and similar which will be added.
>
> That sounds very reasonable.
>
> If there's anything I can do to help out, let me know.
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
"Thou shalt not follow the NULL pointer, for chaos and madness await
thee at its end"
