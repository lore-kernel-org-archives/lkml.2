Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0LHKMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 05:12:54 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49862 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0LHKMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 05:12:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=ZaxwfhQacPVREo52jXZDL6Nb5Y1VOj7dAETiYszsoPPaA7eCN/MSkEE2HLWtFbvzFb
         FlWsjOBlPer7/+nt/uychKIs/SPlzoVevcquEvfwpmmNmMBCDRz4cQToBGIC2dRIwkdp
         0qDuYTkwTO5yZLUOh1lWYyLHOz6ls1ojRfSNc=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1291801990.5992.105.camel@i7.infradead.org>
References: <AANLkTim3FJjVpbjM10kJJhXbONpvGSGQFE+mfGX9pAS6@mail.gmail.com>
	<AANLkTimjVY-6OwRfFUzUbmyacM81M35wf5qDWqAouUYb@mail.gmail.com>
	<1291801990.5992.105.camel@i7.infradead.org>
Date: Wed, 8 Dec 2010 11:12:51 +0100
Message-ID: <AANLkTimxa5hOWC2ouLUfLPpWgoKz6ou2b5NzGwWfNLtZ@mail.gmail.com>
Subject: Re: linux-next: Tree for December 8 (drivers/platform/x86/Kconfig:422:error:
 recursive dependency detected!)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 10:53 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Wed, 2010-12-08 at 10:12 +0100, Corentin Chary wrote:
>>
>> I don't really see how it's a recursive dependency, but maybe it's
>> time to clean this KConfig.
>> What is our current policy about that ?
>>
>> I think we should *depends* on important subsystem (ACPI, INPUT, ...)
>> and select obscure things so
>> that the driver does not get lost if you don't enable the leds.
>
> A better policy is: "NEVER USE SELECT".

Yes, confirmed (see my patch to MLs).

- Sedat -
