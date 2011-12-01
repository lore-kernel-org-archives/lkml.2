Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1LANiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 08:38:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44528 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab1LANiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 08:38:07 -0500
MIME-Version: 1.0
In-Reply-To: <20111201100457.0d3f6b19@notabene.brown>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<20111127230836.GA29728@suse.de>
	<20111128123114.2601bd7c@notabene.brown>
	<20111128072713.GA17724@suse.de>
	<20111128090446.GB18919@core.coreip.homeip.net>
	<20111130063500.GB12052@suse.de>
	<CACRpkdY0vhV6cQgYDhfqAfGWVWWEsiFW4vJ7uumvWwigobpwUw@mail.gmail.com>
	<20111201100457.0d3f6b19@notabene.brown>
Date: Thu, 1 Dec 2011 14:38:06 +0100
Message-ID: <CACRpkdZ2=OVNEgPt6utg3fWqD9qLkgoqmQLfyfP1RQbJ2OqskA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
From: Linus Walleij <linus.walleij@linaro.org>
To: NeilBrown <neilb@suse.de>, Grant Likely <grant.likely@secretlab.ca>
Cc: Greg KH <gregkh@suse.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, myungjoo.ham@gmail.com,
        linux-kernel@vger.kernel.org, Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 12:04 AM, NeilBrown <neilb@suse.de> wrote:

> So: do you know what specific concerns have been expressed concerning gpio
> and userspace?  I think it best to address specific concern rather than throw
> it all out and start again.

No but I have these generic statements from Grant, so it's a bit like the
Delphic oracle giving some advice of the type "don't go there":

[Grant Likely about pinctrl:]
>> https://lkml.org/lkml/2011/9/30/260
>> I'm not convinced that the sysfs approach is
>> actually the right interface here (I'm certainly not a fan of the gpio
>> sysfs i/f), and I'd rather not be putting in unneeded stuff until the
>> userspace i/f is hammered out.
(...)
>> https://lkml.org/lkml/2011/10/4/366
>> I don't want to be in the situation we are now with GPIO,
>> where every time I look at the sysfs interface I shudder.

I am sure he will be able to expand on this when he
gets back on monday.

Yours,
Linus Walleij
