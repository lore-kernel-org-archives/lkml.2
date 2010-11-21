Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0KUWMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 17:12:48 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58965 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab0KUWMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 17:12:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=nnPgJZPdnbpSyQMjDU0rmKXFLJc6Sqog1KfXbfxbLpUrDoGV2O9kBEoRDIHJcMkU7m
         HflxbqOKnPVgTrYQlooAWmOS6YtD4x//p4KXb68kqyqFNz1qa9DUof7crh+VTTjAjwPt
         YQbBuB8jNVN60nyVCJQ8F15rVzZhjteYKno4k=
MIME-Version: 1.0
In-Reply-To: <AANLkTi==VRvn2XjNf3EWZf8jAXwFTrRz8uyFSnnYVi8c@mail.gmail.com>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
 <F46C52ED-8DB8-4347-957D-B9D84406D53F@mit.edu> <AANLkTinyafwe9MyXhSSe5vxEKnTUeLV0AZDWY_uXsu8f@mail.gmail.com>
 <20101121130236.GE23423@thunk.org> <20101121172906.GD3703@kroah.com>
 <AANLkTik6MQjYTCQ4wtyRpOGb94uyUTA+juvX-8UsP95J@mail.gmail.com>
 <20101121203124.1ba8212e@lxorguk.ukuu.org.uk> <AANLkTi==VRvn2XjNf3EWZf8jAXwFTrRz8uyFSnnYVi8c@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 21 Nov 2010 14:12:25 -0800
X-Google-Sender-Auth: VyBqYd8PBt8RfauaJD9uuUkWhPA
Message-ID: <AANLkTi=PQmAfNPFj9pytgP0yMX+B8eZ6Bg3KYwyZZsO3@mail.gmail.com>
Subject: Re: Challenges with doing hardware bring up with Linux first
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, "Ted Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 1:47 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Sun, Nov 21, 2010 at 12:31 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>> Right -- which is why ideally I think it'd be nice to have an open
>>> permissive stack people shared. My preference would be to just pick up
>>
>> Which we know in practice they won't. They'll sit on fixes (often
>> security fixes) and tweak and add private copies of features. In turn the
>> Linux one could then only keep up by adding features itself - which would
>> have to be GPL to stop the same abuse continuing.
>>
>> It's a nice idea but the corporations exist to make money and adding
>> proprietary custom stack add-ons is clearly a good move on their part to
>> do that.
>
> I agree completely with you. Its up to companies to decide whether or
> not they want to do that and ultimately traditionally companies have
> preferred not to. I actually think there is more to it than not
> wanting though... As I see it without people upstream working for some
> of these companies its really hard for them to get these ideas and
> actually believe in the possibility of it and the benefits. I'm
> voicing this publicly to our own managers and lkml because I'd like to
> see that companies get the message because realistically I really
> don't expect anything like this has been *seriously* considered
> before. When I ask people about it, I often hear people say they think
> it'd be nice, but that's about it. Nothing more. No push, no action.
> Its to the industry's best interest IMHO. Even if a common 802.11
> stack was shared, if it was permissive licensed companies could still
> go on and hack their own proprietary crap on top if they so wish, so
> that would still be an option.
>
> My point with all this thread is this: companies tend to not think out
> of the proprietary box they have been put in by old driver development
> habits, and driver development should not be so hard and tedious. They
> should start considering working on more open solutions even for
> proprietary operating systems, under a permissive license. I suspect
> this will help out with resources considerations, bug fix propagation
> and coordination between supporting different Operating Systems. We
> also stand to gain from this on Linux too, after all a driver bug fix
> for hardware sensitive code will need to be propagated to other OSes
> anyway.
>
> I can surely ignore the other OSes and their IMHO their terrible
> software practices but I can't because although it only affects Linux
> in a tedious way I think we can do better and strive for that. If
> sharing an 802.11 stack seems like a pipe dream oh well, at least I
> think we should consider opening up the code for the other OSes and
> let communities help with that crap for our company. Let it evolve
> naturally. The benefits of FOSS cannot just only benefit Linux.

Maybe what we need is a BSD guy at Atheros :)

  Luis
