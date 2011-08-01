Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab1HARdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 13:33:21 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52907 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab1HARdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 13:33:15 -0400
MIME-Version: 1.0
In-Reply-To: <1312188139.18010.104.camel@i7.infradead.org>
References: <1312141497-13854-1-git-send-email-lacombar@gmail.com>
	<1312143643.12369.32.camel@i7.infradead.org>
	<CACqU3MXak0Yo+VDQNEqT9rTJ5CjdU6jJ-C1Km7GauMQ+qGW+vg@mail.gmail.com>
	<1312151687.18010.31.camel@i7.infradead.org>
	<317e3210947c039a33b970300e62d53d.squirrel@xenotime.net>
	<1312188139.18010.104.camel@i7.infradead.org>
Date: Mon, 1 Aug 2011 13:33:14 -0400
Message-ID: <CACqU3MU1yS73++j3H00fbfeBpmKZJ=S93SObnccsw+Bto4V_8w@mail.gmail.com>
Subject: Re: [PATCH] kbuild: honor the ARCH setting of the existing configuration
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 1, 2011 at 4:42 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Sun, 2011-07-31 at 19:05 -0700, Randy Dunlap wrote:
>>
>> > I would love to see $ARCH turned into a proper configuration option.
>>
>> I don't object in principle, but I'm expecting to have to modify/update
>> multiple *working* scripts as a result.  But of course this won't be
>> the first time and I don't expect it to be the last time either.
>> [signed:  eeyore]
>
> :)
>
> Yeah, that's why I'd kind of like to see it done *once*, *properly*.
>
> Arnaud's hack to read it from .config is cute, but might give behaviour
> that people will come to depend on in their scripts and then we take it
> away again.
>
Instead of talking of irrelevant implementation details, what
_behavior_ do you expect ?

The priority I expect is (from most to least):
 1. command line
 2. existing configuration (.config)
 3. Makefile's default
 4. Kconfig default

 - Arnaud
