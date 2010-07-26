Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0GZVzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 17:55:23 -0400
Received: from smtp-out.google.com ([74.125.121.35]:17460 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab0GZVzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 17:55:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=rmFKBYLz7Z03hxudCAV8QAfchvQu1IHIQp0mUlhhIreJCOpNxhCX4esrr+G6moNNC
	Dj2LEMrBOD35N+muqcrPA==
MIME-Version: 1.0
In-Reply-To: <20100726212858.GA15904@suse.de>
References: <20100722182638.GA12712@kroah.com>
	<AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
	<20100722183614.GA5443@suse.de>
	<AANLkTinsd2gWOHb3w9gzvKO5vdwLBT7DZOY+2xCUz_5_@mail.gmail.com>
	<AANLkTimm9XGvK2H55V7N76JPU05iHk_dY5JjOLifQTsr@mail.gmail.com>
	<AANLkTi=OMaKuk+ReeqCfBGes76BjKYyUdqxPOQfH8EcZ@mail.gmail.com>
	<20100726212858.GA15904@suse.de>
Date: Mon, 26 Jul 2010 14:55:18 -0700
Message-ID: <AANLkTimmAfhw7WhPHHU6d4izkzvp2oxOSzNN8JjNu_nU@mail.gmail.com>
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
From: Paul Menage <menage@google.com>
To: Greg KH <gregkh@suse.de>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 2:28 PM, Greg KH <gregkh@suse.de> wrote:
>
> Ok, again, after all of this, who is going to be applying this patch to
> their tree for the .36 merge window?

There's no specific cgroups tree - cgroups patches generally go via akpm.

>
> Or should I apply it to my driver-core one?
>

That sounds like an OK option too.

Paul
