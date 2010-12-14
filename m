Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab0LNFmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 00:42:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35420 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab0LNFmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 00:42:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DWDKf4KD1fQdNb8ehIqSAO/H2eniSleNRCzXawuoSRu3DI1eqgi2HgCRx6zOXTz4t3
         WaoLJuPWvxKPg7J9dyGwNue0XG7eu+N18+V8ya6Cb/XXO2jbq4bWkM29bLzMX44oPTsw
         EG7cggIWxD43FcdzZM3pIfvao78tGrfk9oQlk=
MIME-Version: 1.0
In-Reply-To: <20101213144434.GB18577@redhat.com>
References: <20101210135746.0cf6cbcd.sfr@canb.auug.org.au>
	<20101210092533.4f426650.randy.dunlap@oracle.com>
	<AANLkTi=bw8EcxEffbVV6CfdAPVdM25ZMxHqAmz1yukq3@mail.gmail.com>
	<20101213144434.GB18577@redhat.com>
Date: Tue, 14 Dec 2010 11:42:37 +0600
Message-ID: <AANLkTinuqUTgntBOfBcfLnymKRqn_FAoFquj_Lz7BP-X@mail.gmail.com>
Subject: Re: linux-next: Tree for December 10 (x86 nmi_watchdog)
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 8:44 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Sun, Dec 12, 2010 at 11:27:02AM +0600, Rakib Mullick wrote:
>> On Fri, Dec 10, 2010 at 11:25 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> > On Fri, 10 Dec 2010 13:57:46 +1100 Stephen Rothwell wrote:
>> >
>> >> Hi all,
>> >>
>> >> Changes since 20101209:
>> >
>> >
>> > arch/x86/kernel/apic/hw_nmi.c:28: error: redefinition of 'touch_nmi_watchdog'
>> > include/linux/nmi.h:22: note: previous definition of 'touch_nmi_watchdog' was here
>
> I'll have to checkout that branch to see what got merged.  I thought I
> fixed all these.  Is there a config I can use to duplicate these?
>
Allnoconfig also introduces this breakage.


thanks,
rakib



>
> Cheers,
> Don
>
>
