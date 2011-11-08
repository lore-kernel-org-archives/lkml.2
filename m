Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab1KHQVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:21:13 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:44473 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755158Ab1KHQVM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:21:12 -0500
MIME-Version: 1.0
In-Reply-To: <87sjm31ngz.fsf@ti.com>
References: <1320185752-568-1-git-send-email-omar.ramirez@ti.com>
	<1320185752-568-3-git-send-email-omar.ramirez@ti.com>
	<87sjm31ngz.fsf@ti.com>
Date: Tue, 8 Nov 2011 10:21:08 -0600
Message-ID: <CAB-zwWgd5U+8UNFe_rLY99VpiaHhTqscwYNF+SmuRTyDi+h3+A@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] OMAP4: hwmod data: add mmu hwmod for ipu and dsp
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, lo <linux-omap@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, lm <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 4, 2011 at 6:23 PM, Kevin Hilman <khilman@ti.com> wrote:
>> +     .flags          = HWMOD_INIT_NO_RESET,
>
> Why is this needed?
...
>> +     .flags          = HWMOD_INIT_NO_RESET,
>
> And this?

I have this because the hwmod complains about a failure in hard reset,
even though the reset deassert does complete after the clock is
enabled. Later on, hwmod will warn again because of a wrong state when
enabling, I believe because of the failure on _setup but didn't dig
into it yet.

Regards,

Omar
