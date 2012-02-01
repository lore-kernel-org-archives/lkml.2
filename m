Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab2BAHWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:22:24 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48130 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab2BAHWW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:22:22 -0500
MIME-Version: 1.0
In-Reply-To: <20120131.190830.1189531706541596294.davem@davemloft.net>
References: <4168018.821328016111235.JavaMail.root@5-MeO-DMT.ynet.sk>
 <20120131.115005.1292336126288944173.davem@davemloft.net> <CAGsizzLTHw5Ja3kT-zEN8uK5GrzpmN1bxOhA0OscGL5R6tH3WA@mail.gmail.com>
 <20120131.190830.1189531706541596294.davem@davemloft.net>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@ynet.sk>
Date: Wed, 1 Feb 2012 08:22:02 +0100
X-Google-Sender-Auth: eUozW0CmaPs0dS_zyJFwEI8dv20
Message-ID: <CAGsizzKB=NcAe9KvfZbbPiGvSQ6a9Mj+kBaKtDQziGWJ+eGGRA@mail.gmail.com>
Subject: Re: [patch v7, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
To: David Miller <davem@davemloft.net>
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/1 David Miller <davem@davemloft.net>:
> From: Štefan Gula <steweg@ynet.sk>
> Date: Wed, 1 Feb 2012 00:32:04 +0100
>
>
> You don't understand.
>
> If your code is superfluous in the end, we shouldn't add it in
> the first place.
>
> But if I do relent and let your code in now, we have to live
> with it, and it's associated maintainence costs, FOREVER.
>
> That's why I'm forcing this to be implemented properly from the start,
> so we don't end up with two pieces of code that provide essentially
> the same functionality.
I understand your strategic point of maintenance here and partially
agree with it. And if I understand it correctly, it is to one day have
openvswitch as full replacement of linux bridge code. On the other
hand gretap interface already exists in kernel so that part of the
code is currently also superfluous - what's the plan with that
particular piece of code?. So if this is now only about the
maintenance of my code, I'll be more than happy to continue
maintaining it myself together with you guys. And if it comes in the
future to decision to remove whole gretap code (not just my part) and
replace it with something else that will provide the same or even more
functionality, I have absolutely no problem with that.
