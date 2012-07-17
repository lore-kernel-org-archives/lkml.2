Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab2GQXTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 19:19:43 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40110 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859Ab2GQXT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 19:19:26 -0400
MIME-Version: 1.0
Reply-To: martin-eric.racine@iki.fi
In-Reply-To: <20120717212305.GV28778@vostochny.stro.at>
References: <1342547874.5129.2.camel@henna.lan>
	<20120717193951.GA15208@burratino>
	<CAPZXPQc02=6FnTb_RmgfpW+A4=N_huZW1FUYdjJ=Nt0Y3pqZ+A@mail.gmail.com>
	<20120717212305.GV28778@vostochny.stro.at>
Date: Wed, 18 Jul 2012 02:19:25 +0300
X-Google-Sender-Auth: Cx40hxnWN-SCJeuWxDJWwF1URIk
Message-ID: <CAPZXPQfBPXaRtK3QdY_PA=3GRrUz9+y3aU-2AvedvTwn8tOnqg@mail.gmail.com>
Subject: Re: [PATCH] scripts/package/builddeb: upgrade to current practices
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <martin-eric.racine@iki.fi>
To: maximilian attems <max@stro.at>
Cc: Jonathan Nieder <jrnieder@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, debian-kernel@lists.debian.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/18 maximilian attems <max@stro.at>:
> On Tue, Jul 17, 2012 at 10:46:23PM +0300, Martin-Éric Racine wrote:
>> 2012/7/17 Jonathan Nieder <jrnieder@gmail.com>:
>> >>
>> >>  Package: $fwpackagename
>> >>  Architecture: all
>> >> +Conflicts: firmware-linux-free, firmware-linux-nonfree
>> >> +Provides: firmware-linux-free, firmware-linux-nonfree
>> >> +Replaces: firmware-linux-free, firmware-linux-nonfree
>> >
>> > I assume you mean Breaks+Replaces.  Do the files actually overlap,
>> > or is this change being overly cautious?  I would expect the files
>> > not to overlap because the package build with deb-pkg puts firmware
>> > in a versioned subdirectory "/lib/firmware/<version>".
>>
>> AFAIK they would overlap, hence the Conflicts.
>
> This is wrong and properly fixed in -next.

Max,

Exactly what is wrong with this fix? Could you tell us exactly what
you did differently and why?

Martin-Éric
