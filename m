Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab2BOQOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:14:38 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44645 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038Ab2BOQOh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:14:37 -0500
MIME-Version: 1.0
In-Reply-To: <20120215161032.GE27825@n2100.arm.linux.org.uk>
References: <1329284188.12708.1.camel@phoenix>
	<20120215083609.GD13673@n2100.arm.linux.org.uk>
	<20120215095216.GA29319@mudshark.cambridge.arm.com>
	<20120215101832.GF13673@n2100.arm.linux.org.uk>
	<1329318658.2337.6.camel@localhost>
	<20120215161032.GE27825@n2100.arm.linux.org.uk>
Date: Wed, 15 Feb 2012 11:14:36 -0500
Message-ID: <CACkDPNdX0L0mXTo5Net+A2jKsxws8RWhNocNKOzUqQQptRNqRA@mail.gmail.com>
Subject: Re: [PATCH] ARM: ptrace: Include linux/audit.h to fix build errors
From: Nathaniel Husted <nhusted@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Martin <dave.martin@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in place regarding the endian-ness was put into place long
before my patch and I've no clue the original reasoning behind it.
Thus I'd defer the answer to Eric or other powers that be.

Cheers,
Nathaniel

On Wed, Feb 15, 2012 at 11:10 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Feb 15, 2012 at 10:10:58AM -0500, Eric Paris wrote:
>> On Wed, 2012-02-15 at 10:18 +0000, Russell King - ARM Linux wrote:
>>
>> > So, this gives us two options: either we revert the damned thing and start
>> > over with it (and hopefully audit folk will start co-operating with ARM
>> > folk) or we try to fix up their mess (and potentially they learn they can
>> > dump crap on us.)
>>
>> It must be a conspiracy to screw with the ARM people!  Your jobs were
>> obviously too easy to begin with.  Rahrrrrr!  Down with ARM!
>>
>> No seriously.  I am the audit folks.  You got us all right here in this
>> one e-mail.  You're right, I should have paid more attention to who was
>> in the cc list.  If you want to rewrite it, please feel free!  If you
>> want to push fixes yourself, please feel free!  If you want me to push
>> fixes, please just let me know what is broken and I'll do my best.
>>
>> Sorry.  I just got the patch and was contacted by a number of people off
>> list asking when it was going to go in because they wanted it for their
>> project.  I obviously should have known who the ARM maintainers that
>> would have looked at a patch for the audit system was and should have
>> made sure they commented.  Sorry!  I'll be sure to hit the ARM list if
>> another patch goes by....
>
> And... what about this endian-ness issue?
>
> Frustrated.
>
> I've tried discussing that issue with Nathaniel and haven't got anywhere
> with it (other than, seemingly, it's above his pay grade to know the
> answer.)
>
> Right, I've committed a revert of it to my tree.  When there's more
> interest in the feature, it can be revisited with proper review and
> proper testing of it.
