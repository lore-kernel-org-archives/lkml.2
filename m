Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab0FET4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 15:56:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41784 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab0FET4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 15:56:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=E2fAk2o6VuMOzOJjjuBnTcxu9OTyDgRIhsh581LacnS2V7rU/h3JKIqAIjv71X6aHP
         e0xNtPZ7tlCz7bW0ENeadvM6IvzDjZq1A6ntJN23l9Llv372QlOAjnlWBqLsB7MB77KM
         v5tFB6GdPnZZry+j/o/0290i0pY2kb2inC4vE=
MIME-Version: 1.0
In-Reply-To: <20100605214939.49dd0ee0@schatten.dmk.lab>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<1275149418.4503.128.camel@mulgrave.site>
	<1275156734.1645.496.camel@laptop>
	<201005312314.12391.rjw@sisk.pl>
	<AANLkTil4DLUciWMVmCiiygS2Y1vLZu0Lnfys-w4q3L7W@mail.gmail.com>
	<20100605214939.49dd0ee0@schatten.dmk.lab>
Date: Sat, 5 Jun 2010 22:56:45 +0300
Message-ID: <AANLkTikp1Z9mGOaLf_oE_3qCL7U4oeHaPSp6zkp4eEfL@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Peter Zijlstra <peterz@infradead.org>,
       James Bottomley <James.Bottomley@suse.de>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 5, 2010 at 10:49 PM, Florian Mickler <florian@mickler.org> wrote:
> On Sat, 5 Jun 2010 20:16:33 +0300
> Felipe Contreras <felipe.contreras@gmail.com> wrote:
>> New users will see it has low score; they will not install it. That's
>> a network effect.
>>
>> Having users is the quintessential reason people write code.
>
> That is nice. But how does it impact the problem that suspend blockers
> solve? And why do suspend blockers interfere with that?

It doesn't, I don't know why people keep bringing this argument, I
just though it should not be left open as a valid one.

I should have mentioned that this is indeed irrelevant.

-- 
Felipe Contreras
