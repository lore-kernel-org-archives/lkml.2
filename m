Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015Ab2HYA5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 20:57:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52300 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab2HYA5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 20:57:15 -0400
Message-ID: <503822E6.5040500@gmail.com>
Date: Sat, 25 Aug 2012 10:57:10 +1000
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: wbrana <wbrana@gmail.com>, Chen <hi3766691@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Drop support for x86-32
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <201208231814.21168.tweek@tweek.dk> <CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com> <201208231951.28606.linux@rainbow-software.org> <CAJ7jCmnwXNXmoxT6sdOc-8znsUnnW+Rq8ioJ_8B8KnT0K2uc=A@mail.gmail.com> <1345812057.28613.20.camel@thorin> <CAJ7jCm=bZoHS0-qiiJnUjZb3gP6ibo1xbLsmaUJr2rL4pAU8Eg@mail.gmail.com> <1345823281.28613.34.camel@thorin> <CAJ7jCmmYdQacFtzw+ukGAtrUntnn8S869RcCmbt3cVRY7HYOWw@mail.gmail.com> <CANQmPXgefyCJuzFiAugp6OW2+HtjABSWuQqG33gAU_XgQ1V_2A@mail.gmail.com> <CAJ7jCmme5VNO9aX0SVtmVGUdJj4QODRE4+oPxBE62yCRKcVK6w@mail.gmail.com> <20120824173626.0194625c@pyramind.ukuu.org.uk>
In-Reply-To: <20120824173626.0194625c@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/08/12 02:36, Alan Cox wrote:
>> almost all x86-32 boxes will be trash in 2017, remaining boxes will
>> use long term tree
> People will still be manufacturing 32bit x86 processors in 2017 I'm quite
> sure. You appear entirely out of touch. There are already serious
> discussions going on about things like the kernel modifications needed to
> make 32bit systems run past 2038. 
>
> Besides which what Linux supports is defined by what peope chose to
> contribute code for. We support 32bit 680x0 machines that have been
> obsolete for nigh on 20 years because someone chooses to support them.
>
> For that matter if someone comes along with DEC-10 port and it works as
> was clean without messing up the core I'm sure we'd add that too!
Is that a hint? :P
> Alan
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

