Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab0GMKgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 06:36:37 -0400
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:39699 "EHLO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab0GMKgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 06:36:36 -0400
Message-ID: <4C3C4175.40005@ge.com>
Date: Tue, 13 Jul 2010 11:35:33 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linus <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc: reduce the size of the defconfigs
References: <20100713170945.26d95641.sfr@canb.auug.org.au> <20100713073137.GC26442@pengutronix.de>
In-Reply-To: <20100713073137.GC26442@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König wrote:
> On Tue, Jul 13, 2010 at 05:09:45PM +1000, Stephen Rothwell wrote:
>   
>> This uses Uwe's script (modified by Olof Johansson to speed it up
>> somewhat) to reduce the size of all the powerpc defconfigs.  The resulting
>>     
> IMHO we should add the script to the source, too.  And if it's only for
> me to see Olof's optimisation. :-)
>
>   

As the person who introduced the gef_* PPC defconfigs to the kernel (I
understood this to be best practice), I'm happy to go along with
whatever - as long as I can build a bootable kernel from the mainline
kernel. I think I understand Linus' wish not to see all the defconfig
churn (I get fed up diffing defconfigs, just to read through loads of
additions and removals of undef'ed entires from just the few configs I'm
interested in).

I assume I'm not alone among those attempting to add board support to
the mainline kernel in not being able to keep up with the LKML mailing
list and therefore have missed most of this discussion (think I've
managed to read some of it now). I would very much appreciate some
documentation / guidance on how to use this script - preferably provided
as a comment in the head of the script or/and some pointers in
"Documentation/".

Martyn

>> files have been verified to produce the same .config files by generating
>> them before and after this patch and comparing the results.
>>
>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> ---
>>  100 files changed, 51 insertions(+), 133815 deletions(-)
>>     
> Nice.
>
> Best regards
> Uwe
>
>   


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189

