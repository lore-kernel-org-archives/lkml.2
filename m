Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398Ab0HLQ5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:57:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54077 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab0HLQ5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:57:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PlVO21sr/tXPsfVeaAXWbVmrGTJaEiLDUzWcz9c9i50OTM+gpuPqF3GiVTYNWHEFGh
         16mL6wB3o9S/KPFzlsGCxdRRlI5FGE/jXF6k/r8PEKKXKNy6ZpKgsaUAqXi5xITKP46G
         n+s+AcSEy+FCbfr2yjL7+pR+SyYden4MAgJI4=
MIME-Version: 1.0
In-Reply-To: <20100812140903.GB11362@sirena.org.uk>
References: <20100809181638.GI3026@linux.vnet.ibm.com>
	<AANLkTikwHaKpLdRdxmZj6JDJnsZ+o-jzbVcXhRW3Jmd9@mail.gmail.com>
	<20100811222854.GJ2516@linux.vnet.ibm.com>
	<AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com>
	<20100812010612.GL2516@linux.vnet.ibm.com>
	<AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
	<20100812034435.GA7403@linux.vnet.ibm.com>
	<AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
	<E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu>
	<AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<20100812140903.GB11362@sirena.org.uk>
Date: Thu, 12 Aug 2010 19:57:39 +0300
Message-ID: <AANLkTik=K2znpgiHVgA1oD5Znrmm0Gx45ajfoQ7AwG3F@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Theodore Tso <tytso@mit.edu>, paulmck@linux.vnet.ibm.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 5:09 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Aug 12, 2010 at 02:11:22PM +0300, Felipe Contreras wrote:
>
>> So far, nobody has refuted these:
>>  1) opportunistic suspend needs a good behaved user-space to work properly
>>  2) if suspend blockers are enabled in a system, *all* user-space must
>> implement them to work correctly
>
> For this note that there's a fairly strong expectation that even in a
> phone type environment a sane userspace implementation will involve a
> very large portion of userspace just totally ignoring suspend blockers.
> This means that while it is true that userspace as a whole must have
> support for suspend blockers the changes required are substantially less
> invasive than you appear to expecting.

Correct, but still a considerable amount of changes would need to be
done, which _nobody_ has expressed any intention to do.

Besides, IMO a good mobile platform would share as much as possible
with desktop software. Say, the improvements Nokia has endorsed on the
Telepathy IM framework can only help the people already using it on
the desktop.

However, personally, if I ever have to do './configure
--enable-suspend-blockers', I would think that something that just
doesn't belong has creped by to user-space. I don't see why there
should something particularly different between mobile phones and
laptops, and I think this has been already expressed over, and over.

-- 
Felipe Contreras
