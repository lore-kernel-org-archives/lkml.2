Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605Ab0FEWys (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 18:54:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47230 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab0FEWyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 18:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=mdxdweVm2BCFgXy146qN/ENuwrFQ1PcgpXKSzWYmPfN3/Rk/hNZpQBiOWtMQIr4TZH
         M7Ay+FoEInl60CAU2QdhwtaxdOwuJLf7slczYqsx2V0yEUaBC+9CL3ZKucAQxnCYi81L
         ydkxWxJL0D1DWlFYydAyLizLURRpkW/lu9RFE=
MIME-Version: 1.0
In-Reply-To: <20100604152324.1fa28f2f@nehalam>
References: <AANLkTinSjJsqNvEhJZIE6cJxEkBtg-DO2dqZWMczUy2i@mail.gmail.com> 
	<AANLkTik1isTBolg4IDchOlmKqXOLjQoobZrJ-9bb8ZL5@mail.gmail.com> 
	<20100604152324.1fa28f2f@nehalam>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 5 Jun 2010 15:54:25 -0700
Message-ID: <AANLkTin1s5HCp795WwAgvMbC0PWK0cv7CBmCmY_D3EOW@mail.gmail.com>
Subject: Re: Ethernet drivers wiki page
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: netdev@vger.kernel.org, "H. Peter Anvin" <hpa@kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 3:23 PM, Stephen Hemminger <shemminger@vyatta.com> wrote:
> On Fri, 4 Jun 2010 15:04:17 -0700
> "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
>
>> On Fri, Jun 4, 2010 at 2:52 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> > Where can I start adding documentation for our Ethernet drivers
>> > upstream? I was hoping for a wiki but I don't think we have a netdev
>> > one yet. Shall we create one or piggy back on something else? I'm
>> > reviewing:
>> >
>> > https://wiki.kernel.org/
>> >
>> > FWIW, I want to see something like this:
>> >
>> > http://wireless.kernel.org/en/users/Drivers
>> >
>> > But for ethernet.
>>
>> Since I've stuffed a few ethernet drivers on compat-wireless I might
>> as well start carrying more. So now we'd have 802.11, Bluetooth and
>> Ethernet all backported using the same framework, automatically, down
>> to at least the oldest stable kernel supported listed on kernel.org
>> and using all a generic compat module.
>>
>> I want to document all this crap.
>
> Why not Documentation/networking in kernel source?

I think a wiki works better for this sort of documentation, the
documentation I intend on writing is for end users, not developers.
Users tend to also search on google, not the kernel source.

> There is already documentation there though much of it is out of date.

I think its because a git tree works well for code, but not for
documentation. Technically I'm even an advocate for developer
documentation on wikis too though.

> This has the advantage of having change log and matching kernel version.

With Ethernet I'd just stuff all new drivers into the wiki as they go
into linux-next, after all the drivers would be available immediately
even for use on older kernels, so the information would be up to date,
we could just annotate as per what kernel release what feature went or
what chipsets were supported. For example, see:

http://wireless.kernel.org/en/users/Drivers/ath9k#supported_chipsets

  Luis
