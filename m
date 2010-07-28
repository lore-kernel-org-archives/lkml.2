Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab0G1XuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 19:50:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34423 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab0G1XuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 19:50:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mzy0npa9wpdySE2+R1hv5uLcm6uz3RD4F2JjVUytkxaAUi1tBZiRRovIuApe4CooS4
         tLfUxRrY4KgK5WvzceVSm1jaD9TMtuUWKYhGahIjo64TSS2KerCDjjJ2hoAO2pVAAbUF
         mNM8Akkh9DnkSMiOi1VuAmiKmobhcf+l2H3i8=
MIME-Version: 1.0
In-Reply-To: <20100728074322.GA8147@flint.arm.linux.org.uk>
References: <20100727120805.f583c70b.sfr@canb.auug.org.au>
	<AANLkTin4EAQ48HP3ETDUMqBe2AzcznRuZdBdG+_RhR8x@mail.gmail.com>
	<20100728074322.GA8147@flint.arm.linux.org.uk>
Date: Thu, 29 Jul 2010 01:50:19 +0200
Message-ID: <AANLkTikTdLcYQ2cqt7HOoEANTRYOB_ySqdud5QEs5pd5@mail.gmail.com>
Subject: Re: linux-next: manual merge of the async_tx tree with the arm tree
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Russell King <rmk@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/28 Russell King <rmk@arm.linux.org.uk>:
> On Wed, Jul 28, 2010 at 12:11:19AM -0700, Dan Williams wrote:
>> On Mon, Jul 26, 2010 at 7:08 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > Hi Dan,
>> >
>> > Today's linux-next merge of the async_tx tree got a conflict in
>> > arch/arm/mach-ux500/devices-db8500.c between commit
>> > 6055930cba8fdb2c8855b32bae262aaf69c1fdb4 ("ARM: 6266/1: ux500: add
>> > separate irq lists for DB8500 and DB5500") from the arm tree and commit
>> > 5aa12e8c9c57741606e52f43e62ab1b9dc8e9dcc ("DMAENGINE: ste_dma40: arch
>> > updates for LCLA and LCPA") from the async_tx tree.
>> >
>> > I fixed it up (I think - see below) and can carry the fix as necessary.
>> > --
>>
>> Thanks Stephen!
>>
>> Russell, the dma40 driver updates and related arch fixups have been
>> sitting in next for a month, I'd prefer not to lose this baseline.
>> Assuming this change is brand new any chance the dma40 specific part
>> of this patch can be peeled off and sent through my tree, or are you
>> in a similar "can't/won't" rebase position?
>
> I don't see how the change in the ARM tree could be reasonably split.
> Up to Rabin/Linus to decide what they want to do about this.

Actually the way subsystem maintainers fix up conflicts and resolve them
is a bit of opaque to me, I'd be happy to help in any way possible.

Isn't it so that whoever hits the merge window first goes in and the
other apply Stephens patch before issuing any pull request and be
done with it? That was my naïve idea about these things...

Yours,
Linus Walleij
