Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab0JFB2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:28:32 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:45815 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab0JFB2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:28:31 -0400
Content-Type: text/plain; charset=UTF-8
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, paulus <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 05/18] powerpc: Wire up 44x little endian boot for remaining 44x targets
From: Ian Munsie <imunsie@au1.ibm.com>
To: Josh Boyer <jwboyer@gmail.com>
In-reply-to: <AANLkTins34TrEWj618_4XBRwGGFqRSehwWEp7jBubvsu@mail.gmail.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com> <1285916771-18033-6-git-send-email-imunsie@au1.ibm.com> <AANLkTins34TrEWj618_4XBRwGGFqRSehwWEp7jBubvsu@mail.gmail.com>
Date: Wed, 06 Oct 2010 12:28:29 +1100
Message-Id: <1286327715-sup-584@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Josh Boyer's message of Fri Oct 01 21:27:37 +1000 2010:
> > From: Ian Munsie <imunsie@au1.ibm.com>
> >
> > I haven't tested booting a little endian kernel on any of these targets,
> > but they all claim to be 44x so my little endian trampoline should work
> > on all of them, so wire it up on:
> >
> > bamboo
> > katmai
> > kilauea
> > rainer
> > sam440ep
> > sequoia
> > warp
> > yosemite
> > ebony
> 
> I see no reason to do this at all.  If you haven't tested them and
> there is no demand, there's no reason to wire them up.  Some might
> actively want to disallow LE mode anyway, like the Warp or Sam440EP.

I wasn't aware that the Warp and Sam440EP disallowed LE mode - I'll
definitely unwire them and move the ARCH_SUPPORTS_LITTLE_ENDIAN to just
the sub-arch's that support it.

As for the other boards, I would like to wire them up if they are able
to support LE mode - If anyone has one handy I would love to hear if
they are able to begin booting a LE kernel with these patches, or when &
how they fail.

Cheers,
-Ian
