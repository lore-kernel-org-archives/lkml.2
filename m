Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab1JCKMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:12:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066Ab1JCKMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:12:19 -0400
Message-ID: <4E898A69.8060306@redhat.com>
Date: Mon, 03 Oct 2011 12:11:53 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jon Mason <mason@myri.com>
CC: Sven Schnelle <svens@stackframe.org>, Simon Kirby <sim@hostway.ca>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: Workaround for Intel MPS errata
References: <4E82017C.3010304@redhat.com> <CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com> <4E8215B6.1020108@redhat.com> <20110930001633.GA11436@myri.com> <4E882E34.8040409@redhat.com> <20111003045823.GA13222@myri.com>
In-Reply-To: <20111003045823.GA13222@myri.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 06:58 AM, Jon Mason wrote:
> On Sun, Oct 02, 2011 at 11:26:12AM +0200, Avi Kivity wrote:
> >  On 09/30/2011 03:16 AM, Jon Mason wrote:
> >  >Hey Avi,
> >  >Can you try this patch?  It should resolve the issue you are seeing.
> >
> >  It doesn't; the fixup: label is not reached (though I do have an
> >  0x25d4 device).
> >
> >  -- 
> >  error compiling committee.c: too many arguments to function
> >
>
> I found a system with a 5000X Memory controller (which should have the
> same errata).  It doesn't have the faulty bit (perhaps better BIOS).  I
> was able to findout why the code in the previous patch wasn't working,
> but wasn't able to cause the crash by setting the bit from the errata.
> The reworked version of the previous patch found below should resolve
> the issue.  Please test it if you can.

Will be happy to test, but patch appears to be against a different tree?

$ git apply -C2 .git/rebase-apply/patch
.git/rebase-apply/patch:75: trailing whitespace, shock horror.
      *
Context reduced to (2/2) to apply fragment at 1362
Context reduced to (2/2) to apply fragment at 1475
error: patch failed: drivers/pci/probe.c:1433
error: drivers/pci/probe.c: patch does not apply




-- 
error compiling committee.c: too many arguments to function

