Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab2GRTgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 15:36:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab2GRTg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 15:36:29 -0400
Message-ID: <50071014.6040301@redhat.com>
Date: Wed, 18 Jul 2012 15:35:48 -0400
From: Jon Masters <jcm@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Dennis Gilmore <dennis@ausil.us>, Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
References: <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com> <201207071927.13135.arnd@arndb.de> <20120710071023.GA10456@gmail.com> <20120710101018.GE15120@arm.com> <yw1x8vekd309.fsf@unicorn.mansr.com> <CA+55aFxL6uEre-c=JrhPfts=7BGmhb2Js1c2ZGkTH8F=+rEWDg@mail.gmail.com> <20120717221839.GA4856@arm.com> <1342564536.1898.1.camel@joe2Laptop> <5006207D.1010708@jonmasters.org> <20120718102712.46b8d7ff@adria.ausil.us> <20120718171426.GA4240@arm.com>
In-Reply-To: <20120718171426.GA4240@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 01:14 PM, Catalin Marinas wrote:

> Debian has different names for the architecture and compiler triplet:
> amd64 with x86_64-linux-gnu, similar for x32. None of these match the
> arch/x86/ Linux directory. Even if there is some confusion initially, it
> will go away in a relatively short time (if not ARM can sponsor a water
> drinking event ;).

Sign me up for the water drinking. I'll also take ARM branded Kool-Aid,
though it's been argued that I've already found a good dose of that.

You make a good point, Catalin. Aside from arguing over the name, we
should bear in mind that ARM management have made some decisions around
AArch64 and I suspect as it starts to appear in more use, there will be
less confusion. It's early now. There is no silicon out there for us to
use at this point in the process, etc. etc. So we should think with a
mindset of 2-3 years from now rather than where we were yesterday.

Jon.
