Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2GBToH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 15:44:07 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:49632 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab2GBToF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 15:44:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: linux-next : cpuidle - could you add my tree please
Date: Mon, 2 Jul 2012 21:49:36 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        "Lists Linaro-dev" <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linux-next@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Lee <rob.lee@linaro.org>, "lenb@kernel.org" <lenb@kernel.org>
References: <4FDEE98D.7010802@linaro.org> <CACRpkdYaLweX-4YkWotuFFWoqEjOLKoNCsurCxxWNfq7QznPnw@mail.gmail.com> <4FF19947.3040608@linaro.org>
In-Reply-To: <4FF19947.3040608@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207022149.36629.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 02, 2012, Daniel Lezcano wrote:
> 
> On 07/02/2012 11:09 AM, Linus Walleij wrote:
> > On Mon, Jun 25, 2012 at 3:27 PM, Daniel Lezcano
> > <daniel.lezcano@linaro.org> wrote:
> > 
> >> we discussed last week to put in place a tree grouping the cpuidle
> >> modifications [1]. Is it possible to add the tree ?
> >>
> >> git://git.linaro.org/people/dlezcano/cpuidle-next.git #cpuidle-next
> > 
> > Thanks for doing this.
> > 
> > Since MAINTAINERS is lacking a listed maintainer for cpuidle,
> > are you also going to add yourself as maintainer and list this
> > tree in that file, or is this a one-time exercise?
> 
> I will be glad to do that if Len and Rafael agree on that.

Len Brown has been a cpuidle maintainer for some time now.  Moreover,
he's been taking patches, but Linus refused to pull his entire tree during the
last merge window (as you probably know).  I honestly don't think this is
a good enough reason for replacing him as a cpuidle maintainer by force.

So, you should ask Len whether or not he's willing to pass the cpuidle
maintenance to someone else.

I know that Len hasn't been responsive recently, but I also know that he
_does_ respond to inquiries sent directly to him.

Thanks,
Rafael
