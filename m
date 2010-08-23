Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab0HWUL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:11:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54020 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab0HWULX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:11:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ELzKhWwlxhk4FzLK2cJVsRwjca+RZQlw/ExKOAFSmzucNn/vCPUyh2QXiBxYarqvrg
         bDqKZOyI0vjl+zVXBoO30bcu0goNbPJgmzUozVDLimh7tLR0HzHnZ47RxkpMUs3gZb3x
         cc5HyqtnQXtLmafDRkq94tQjMCvPG/aSO4YTg=
MIME-Version: 1.0
In-Reply-To: <1282586336.11194.30.camel@mulgrave.site>
References: <4C69653E.6050808@vlnb.net>
	<1282077040.16098.47.camel@mulgrave.site>
	<4C6C1DC1.8090208@vlnb.net>
	<1282164188.10878.22.camel@mulgrave.site>
	<4C702030.2070306@vlnb.net>
	<1282423128.3015.35.camel@mulgrave.site>
	<AANLkTin9STqUz440fCOEWW=YmedVQtQWU2JLO2wZCt5j@mail.gmail.com>
	<1282582740.11194.17.camel@mulgrave.site>
	<AANLkTinkYCPA-ZdWFhdriCyrK7J8Okj5HWqg7JsGZ7ry@mail.gmail.com>
	<1282586336.11194.30.camel@mulgrave.site>
Date: Mon, 23 Aug 2010 22:11:22 +0200
X-Google-Sender-Auth: zi-7lM3T5x3NQiNw1roe47TXWbI
Message-ID: <AANLkTinTg3oHmc6N-zu_Czg7s5dPwvxwgLa-eBuHwSBe@mail.gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
From: Bart Van Assche <bvanassche@acm.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Gennadiy Nerubayev <parakie@gmail.com>,
        Vladislav Bolkhovitin <vst@vlnb.net>,
        scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 7:58 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Mon, 2010-08-23 at 19:44 +0200, Bart Van Assche wrote:
>> On Mon, Aug 23, 2010 at 6:59 PM, James Bottomley
>> <James.Bottomley@suse.de> wrote:
>> >
>> > My basic conclusion was that there's no incredible discriminator between
>> > LIO and STGT (although there are reams written on which performs better
>> > in which circumsances, is useful for clustering, supports ALUA, etc.
>> > each with partisans for the features).  If the two communities can't
>> > work together (as seems to be the case) and I have to choose one, I'll
>> > go by what helps me which, as I've said before, are:
>> >
>> >     1. That it would be a drop in replacement for STGT (our current
>> >        in-kernel target mode driver), since he only wanted a single
>> >        SCSI target infrastructure.
>> >
>> >     2. That it used a modern sysfs based control and configuration
>> >        plane.
>> >
>> >     3. That the code was reviewed as clean enough for inclusion.

Let us return to the three acceptance criteria. At this time none of
the existing kernel-based target frameworks support ibmvstgt and hence
none of them satisfy criterion [1]. Yet these criteria have been used
to decide that one kernel-based target framework will be accepted and
that the other will not be accepted. I'm afraid that I missed
something ?

Also, you write that you, as a kernel maintainer, might become in a
position that you have to choose a target framework. I would
appreciate it if you would take the time to reread the document
Documentation/ManagementStyle. This document was written by Linus
Torvalds and explains that a kernel maintainer should try to avoid
having to take such decisions. The whole first chapter of that
document is devoted to this subject.

I regret that you got involved personally in this discussion. It would
have been a lot easier for everyone if you would have been able to
keep a neutral position.

Bart.
