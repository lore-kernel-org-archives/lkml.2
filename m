Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab1KHRlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:41:52 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:34622 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932361Ab1KHRlt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:41:49 -0500
From: Kevin Hilman <khilman@ti.com>
To: "Ramirez Luna\, Omar" <omar.ramirez@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, lo <linux-omap@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, lm <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] OMAP4: hwmod data: add mmu hwmod for ipu and dsp
Organization: Texas Instruments, Inc.
References: <1320185752-568-1-git-send-email-omar.ramirez@ti.com>
	<1320185752-568-3-git-send-email-omar.ramirez@ti.com>
	<87sjm31ngz.fsf@ti.com>
	<CAB-zwWgd5U+8UNFe_rLY99VpiaHhTqscwYNF+SmuRTyDi+h3+A@mail.gmail.com>
Date: Tue, 08 Nov 2011 09:41:39 -0800
In-Reply-To: <CAB-zwWgd5U+8UNFe_rLY99VpiaHhTqscwYNF+SmuRTyDi+h3+A@mail.gmail.com>
	(Ramirez Luna's message of "Tue, 8 Nov 2011 10:21:08 -0600")
Message-ID: <8762iuqzos.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Ramirez Luna, Omar" <omar.ramirez@ti.com> writes:

> Hi,
>
> On Fri, Nov 4, 2011 at 6:23 PM, Kevin Hilman <khilman@ti.com> wrote:
>>> +     .flags          = HWMOD_INIT_NO_RESET,
>>
>> Why is this needed?
> ...
>>> +     .flags          = HWMOD_INIT_NO_RESET,
>>
>> And this?
>
> I have this because the hwmod complains about a failure in hard reset,
> even though the reset deassert does complete after the clock is
> enabled. Later on, hwmod will warn again because of a wrong state when
> enabling, I believe because of the failure on _setup but didn't dig
> into it yet.

Please dig deeper into the reset failure.

We don't merge HWMOD_INIT_NO_RESET changes without a very good reason
(that is also well described in the changelog.)

Thanks,

Kevin
