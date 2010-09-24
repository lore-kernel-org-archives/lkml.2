Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0IXNaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:30:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45765 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab0IXNay convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:30:54 -0400
MIME-Version: 1.0
In-Reply-To: <20100924131914.GA1965@kroah.com>
References: <AANLkTinGJmAzdd=HOKZYSh69F6T9HMznOKW5BS90=Q-4@mail.gmail.com>
	<20100924131914.GA1965@kroah.com>
Date: Fri, 24 Sep 2010 15:30:52 +0200
Message-ID: <AANLkTimnUrWQ6qrUi_91mrZ3BF8e91997ScKY6OMSBSk@mail.gmail.com>
Subject: Re: Long maintenance kernel versions.
From: Geoffrey Said <geoffrey@2x.com>
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the info.  Unfortunately I missed the .32 announcement as I
am not always working on kernel integration.

Are there any future planned versions for long term maintenance, like
say the .36?

Thanks again.

On Fri, Sep 24, 2010 at 3:19 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Sep 24, 2010 at 07:10:09AM +0200, Geoffrey Said wrote:
>> To whom it may concern.
>>
>> I would like to put forward the following questions.  Hope that I am
>> not making a fool of myself!
>>
>> How is the procedure by which a certain kernel version is declared as
>> a long maintenance version?
>
> There really isn't a set procedure yet.
>
>> Is the version decided before or after the release of the stable kernel?
>
> Sometimes after, sometimes before.
>
>> And where can I check for planned long term maintenance versions?
>
> You can ask.
>
> Here's how the last 3 "long-term" releases came about:
>  .16 - turned out that my employeer was using it for an enterprise
>        kernel release, so it made my "day job" a lot easier to keep it
>        going for a longer-than-normal period of time.  People liked
>        this, so it kept going.
>  .27 - Same as before.
>  .32 - Now things got interesting.  Some kernel developers who "worked"
>        for different distros got together and talked about picking a
>        release that their distros could sync up on and become a
>        long-term released kernel.  That ended up being the .32 kernel
>        and we planned it ahead of time.  This resulted in all of the
>        major distros relying on this kernel for their releases.
>
> And that's it.  Pretty simple, but effective.
>
>> I am asking the above questions because we are migrating our Linux OS
>> to the 2.6.34 kernel and we have learned that this will not be
>> actively maintained and we are advised to switch to the 35 one.
>> Since a lot of effort has been put to migrate to the 2.6.34 kernel and
>> a lot of testing has been done, it is frustrating to hear the above
>> news.
>
> You can always ask me ahead of time what is going on with this type of
> thing, that's the best way.  I am easy to get ahold of if you have
> questions like this.
>
>> From our point of view it would be nice to declare a version log term
>> maintenance before or at least on release so that we can migrate
>> between long-term kernels.
>
> For .32, I did announce this ahead of time, perhaps you missed that.
>
> Hope this helps,
>
> greg k-h
>



-- 
Geoffrey Said
Software Developer
2X Software - http://www.2x.com
Developers of virtual computing software
2X VirtualDesktopServer - 2X ApplicationServer - 2X LoadBalancer - 2X
ThinClientServer

Tel: +356 2258 3800
Fax:+356 2137 7078
