Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab1FGQEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:04:14 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:54308 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753472Ab1FGQEN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:04:13 -0400
From: Kevin Hilman <khilman@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Colin Cross <ccross@android.com>, linux-omap@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, tarun.kanti@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ARM: omap4: gpio: fix setting IRQWAKEN bits
Organization: Texas Instruments, Inc.
References: <1307392698-21170-1-git-send-email-ccross@android.com>
	<87boyav99n.fsf@ti.com>
	<BANLkTik-UK9EPsnUkQeih+Zf_9py-X2Q0A@mail.gmail.com>
Date: Tue, 07 Jun 2011 09:04:09 -0700
In-Reply-To: <BANLkTik-UK9EPsnUkQeih+Zf_9py-X2Q0A@mail.gmail.com> (Grant
	Likely's message of "Mon, 6 Jun 2011 19:06:36 -0600")
Message-ID: <87hb81r5l2.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely <grant.likely@secretlab.ca> writes:

> On Mon, Jun 6, 2011 at 5:18 PM, Kevin Hilman <khilman@ti.com> wrote:
>> Hi Colin,
>>
>> Colin Cross <ccross@android.com> writes:
>>
>>> Setting the IRQWAKEN bit was overwriting previous IRQWAKEN bits,
>>> causing only the last bit set to take effect, resulting in lost
>>> wakeups when the GPIO controller is in idle.
>>>
>>> Replace direct writes to IRQWAKEN with MOD_REG_BIT calls to
>>> perform a read-modify-write on the register.
>>>
>>> Signed-off-by: Colin Cross <ccross@android.com>
>>
>> Thanks, I'll queue these both for Grant for the 3.0-rc fixes along with
>> another GPIO fix for a section mismatch I have queued.
>>
>> Minor: now that this driver has moved to drivers, I changed the subject
>> prefixes slightly.  They now read:
>>
>> GPIO: OMAP: fix setting IRQWAKEN bits for OMAP4
>> GPIO: OMAP: add locking around calls to _set_gpio_triggering
>
> If you're collecting fixes for Linus anyway, go ahead and add my a-b
> line and include these two to send on to Linus
>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>
> Or, if they are only gpio fixes, then I'd also be happy to get a git
> pull req for the changes.  :-)
>

I have a GPIO-only queue, so I'll have a pull req for you today.

Kevin
