Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab1DMXnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 19:43:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45781 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab1DMXnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 19:43:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=S7GMHOkKByjybkhIPShsN7YJlMZjfYg/Jn7lgL363us5t4mzB1DyhUuZOB6ayUpbDz
         ooWeO1i/o4bNi7p5YJyFtLM/8z9UQw6FlbEZSHZJk1qzCHHBkOUsTl6e5HCsPppXVyWZ
         r69/3nPuWKt7yxn+HKWMFYcdtEhKLPsvJyDnE=
MIME-Version: 1.0
In-Reply-To: <1302736869.28876.91.camel@pasglop>
References: <19876.35918.322649.256455@pilspetsen.it.uu.se>
	<1302646173.28876.53.camel@pasglop>
	<1302652502.28876.76.camel@pasglop>
	<19877.23529.745123.819112@pilspetsen.it.uu.se>
	<1302685102.28876.81.camel@pasglop>
	<BANLkTimc84A8kddarnhvrcab3iKZc0HZAg@mail.gmail.com>
	<1302736869.28876.91.camel@pasglop>
Date: Wed, 13 Apr 2011 18:43:13 -0500
Message-ID: <BANLkTika8FY1dD_hOQ4wMhHzuQ2Qt8fg7A@mail.gmail.com>
Subject: Re: [regression] 2.6.39-rc[1-3] fail to boot on G5 PowerMac
From: kevin diggs <diggskevin38@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 13, 2011 at 6:21 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Wed, 2011-04-13 at 12:52 -0500, kevin diggs wrote:
>> > Actually I do get a crash in X later on... something in the radeon
>> DRM
>> > interrupt code is getting what looks like a NULL dereference. I'll
>> try
>> > to dig that one later on. I don't know if it's related to your
>> problem
>> > at all though.
>> >
>> In this context, what does 'crash' mean? The X thingy goes down? Or
>> the whole OS?
>
> Depends, with xmon enabled you get into xmon :-) Dunno if the oops is
> fatal but it could be.
>
> Cheers,
> Ben.
>
>

As I think I have the same hardware as you (7,3, radeon 9600) If you
can tell me how to reproduce it maybe I can poke around a little.
Thus, at least temporarily, freeing you up for other stuff.

I kinda need a break from fighting with GCC.

kevin
