Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1EPJp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:45:57 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:44426 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202Ab1EPJpz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:45:55 -0400
MIME-Version: 1.0
In-Reply-To: <20110516092309.GD12325@elte.hu>
References: <1305297838-4015-1-git-send-email-j-pihet@ti.com>
	<20110513144830.GB32688@elte.hu>
	<BANLkTikkd9bNRLF1iDAz9Jwrnon3A=j44g@mail.gmail.com>
	<20110516092309.GD12325@elte.hu>
Date: Mon, 16 May 2011 11:45:50 +0200
Message-ID: <BANLkTin6-TZHkw5iSb034Ur5xLfQoGRtLw@mail.gmail.com>
Subject: Re: [PATCH] perf: export power_start and power_end tracepoints
From: "Pihet-XID, Jean" <j-pihet@ti.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jean Pihet <jean.pihet@newoldbits.com>, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>, linux-omap@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 11:23 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jean Pihet <jean.pihet@newoldbits.com> wrote:
>
>> Adding l-o and linux-pm MLs. The original post is at
>> http://www.spinics.net/lists/kernel/msg1186554.html
>>
>> On Fri, May 13, 2011 at 4:48 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * jean.pihet@newoldbits.com <jean.pihet@newoldbits.com> wrote:
>> >
>> >> From: Jean Pihet <j-pihet@ti.com>
>> >>
>> >> If used in a module both tracepoints need to be exported by the
>> >> kernel.
>> >
>> > but it's not used by any module in the kernel AFAICS, so why is this needed?
>> Not currently, that is why the error went unnoticed. I think it is
>> better to fix it now than later.
>>
>> I am working on a plan to clean-up and isolate the OMAP PM code from
>> the core code and to provide the PM functionality as a module. This
>> effort is part of the 'remove the crazy ARM churn' from the kernel.
>
> Feel free to keep this patch with those modifications/cleanups:
>
> Acked-by: Ingo Molnar <mingo@elte.hu>
>
> but please make sure you push it together, i.e. never export something
> (knowingly) without having in-tree use for it.
Ok will push the changes together when they are ready.

>
> Thanks,
>
>        Ingo
>

Thanks,
Jean
