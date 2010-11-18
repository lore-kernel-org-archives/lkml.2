Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab0KRJoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:44:10 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55389 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab0KRJoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:44:04 -0500
MIME-Version: 1.0
X-Originating-IP: [81.245.230.134]
In-Reply-To: <20101118093656.GD28467@elte.hu>
References: <1289498595-25806-1-git-send-email-trenn@suse.de>
	<201011140734.07770.trenn@suse.de>
	<20101118080132.GH32621@elte.hu>
	<201011181027.09363.trenn@suse.de>
	<20101118093656.GD28467@elte.hu>
Date: Thu, 18 Nov 2010 10:44:02 +0100
Message-ID: <AANLkTinwDihng1zoGdjiVUPFOpRcznig8p1wRJ5Y7WU9@mail.gmail.com>
Subject: Re: [PATCH 2/3] PERF(kernel): Cleanup power events
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Renninger <trenn@suse.de>, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 10:36 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Thomas Renninger <trenn@suse.de> wrote:
>
>> On Thursday 18 November 2010 09:01:32 Ingo Molnar wrote:
>> ...
>> > > @Ingo: If this does not go into x86/tip, but perf or whatever tree, it would
>> > > be great if you can ping me as soon as this stuff is in.
>> >
>> > Mind sending the latest version which has been adjusted/fixed and all acks added?
>> Done.
>> This time with lkml excluded as there were only cleanups/fixes
>> due to a messed merge.
>
> Please do not exclude lkml from such iterations of patches in the future - every
> modification to patches is relevant - often pure resends get resent to lkml as well.

Ok for me!

Acked-by: Jean Pihet <j-pihet@ti.com>

Note the ti.com email address to be used for Sign-offs and Acks.

Thanks,
Jean

>
> Thanks,
>
>        Ingo
>
