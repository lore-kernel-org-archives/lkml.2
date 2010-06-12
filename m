Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab0FLFgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 01:36:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40784 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab0FLFgx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 01:36:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bgxSZrTOVL5JE6Sis/fUogBeioFw+4xUbyXCVPHM1BuwQZxtjnkNNvpOQ/yiohZx4q
         8mr/A/FMnUZHL944wNr1KBtQsPGOq22I9CtKxzpQ+v6oEOSTpWOA3GmXG9/pB7u+fFvo
         Jmq1ca6YPwvtPccarooq691WyHANCCMkrcscc=
MIME-Version: 1.0
In-Reply-To: <1276258936.16663.39.camel@e102109-lin.cambridge.arm.com>
References: <1274901104-22133-1-git-send-email-marek.vasut@gmail.com> 
	<20100526191425.GD6232@n2100.arm.linux.org.uk> <201005262115.57282.marek.vasut@gmail.com> 
	<20100526201824.GA16418@n2100.arm.linux.org.uk> <20100610135609.GC4514@ucw.cz> 
	<1276258936.16663.39.camel@e102109-lin.cambridge.arm.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 12 Jun 2010 13:36:32 +0800
Message-ID: <AANLkTin5QDIZGJ_SvNxrK5C3ewT3DcMJNqrryYgMlEmy@mail.gmail.com>
Subject: Re: [PATCH] sa1111: Prevent deadlock in resume path
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Pavel Machek <pavel@ucw.cz>, Marek Vasut <marek.vasut@gmail.com>,
       julia@diku.dk, Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org,
       Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 8:22 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Thu, 2010-06-10 at 14:56 +0100, Pavel Machek wrote:
>> On Wed 2010-05-26 21:18:24, Russell King - ARM Linux wrote:
>> > On Wed, May 26, 2010 at 09:15:57PM +0200, Marek Vasut wrote:
>> > > You want me to fight your patch tracking system or will you just merge it into
>> > > your tree ?
>> >
>> > What do you mean "fight" ?  Just send a standard git formatted patch
>> > to the email address with an additional KernelVersion: tag.  It's
>> > not at all hard.
>>
>> You are linux kernel maintainer. Start acting as one. It is not at all
>> hard.
>>
>> Alternatively, just remove KernelVersion: checking in  your
>> scripts.
>
> BTW (and I'm not complaining about Russell's patch system here), how can
> we get the linux-arm-kernel list subscribed to patchwork.kernel.org?
> That would be useful for grabbing RFC/CFT patches.
>

CC'ed Jeremy Kerr.

Jeremy,

Is it OK to add linux-arm-kernel?
