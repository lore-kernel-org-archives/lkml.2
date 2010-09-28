Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690Ab0I1CHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:07:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59954 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005Ab0I1CHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:07:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=S1Andxurj2TrU1fAl0F289IHL9A5joCIc8mQ6EXqXaJfGWTkU6wG12a5URGFR8ntEV
         OJJVMOEL0n4TA8cuKxaAHxnQh29EOGJ+opqh3yBj7EyC9wr0xA3DsPrGw7ogNO23fgG9
         8Baqw4EwqZov5mJF6NHgcq1DYeWaraLm2GEOs=
Message-ID: <4CA14DF6.3070505@gmail.com>
Date: Mon, 27 Sep 2010 19:07:50 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Finn Thain <fthain@telegraphics.com.au>
CC: Joe Perches <joe@perches.com>, "John W. Linville" <linville@tuxdriver.com>,
        trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org,
        linux-ide@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [RFC v4]update broken web addresses in the kernel.
References: <1285525875-9920-1-git-send-email-justinmattock@gmail.com>  <20100927151005.GC11086@tuxdriver.com> <1285603383.1732.106.camel@Joe-Laptop> <4CA0CB0F.3060303@gmail.com> <alpine.OSX.2.00.1009281119570.276@localhost>
In-Reply-To: <alpine.OSX.2.00.1009281119570.276@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 06:37 PM, Finn Thain wrote:
>
> On Mon, 27 Sep 2010, Justin P. Mattock wrote:
>
>> On 09/27/2010 09:03 AM, Joe Perches wrote:
>>> On Mon, 2010-09-27 at 11:10 -0400, John W. Linville wrote:
>>>> On Sun, Sep 26, 2010 at 11:31:15AM -0700, Justin P. Mattock wrote:
>>>>> Below is an updated patch from the original fixing broken web
>>>>> addresses in the kernel. Thanks for all the help and info on this
>>>>> to everybody.. Hopefully I didnt miss any of them(if so let me
>>>>> know, and I'll resend).
>>>> Changing a URL for a relocated page is one thing, but removing links
>>>> isn't necessarily a great idea.  Even if the site is technically
>>>> gone, it may be possible to find information e.g through the
>>>> Internet Archive Wayback Machine.
>>>
>>> Perhaps it'd be better to scrape the contents of the various web
>>> pages, collect them somewhere like wiki.kernel.org and encourage
>>> others to put new contributions in that site.
>
> The copyright problem aside, this might be a good idea for material not
> already archived but I don't think it makes sense to start a new
> archive when archive.org (or other) has the information.
>
> And which version(s) do you scrape? I discussed some problems with
> changing URLs in another thread: http://lkml.org/lkml/2010/9/22/22
>
> Anyway, without knowing what future archive(s) would be available or
> relevant to any given URL in the future, I think the best we might do is a
> "Retrieved on YYYY-MM-DD" qualification for new URLs.
>
>>
>>
>> yeah I think somebody was saying something about having a separate file,
>> with all the web addresses in them or something...In any case, up to you
>> guys..
>
> I don't see how moving the addresses would help.
> And would it not make the information harder to find?
>
> Finn
>

depends on how the setup is.. I was thinking of having some kind of 
letter/number scheme i.e. (A-13) in the comment, then in the file with 
all the addresses under article "A" 13th address down you would have the 
web address.(but keep in mind that's just speculation..)

Justin P. Mattock


