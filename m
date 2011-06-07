Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab1FGBG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 21:06:59 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:47751 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab1FGBG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 21:06:58 -0400
MIME-Version: 1.0
In-Reply-To: <87boyav99n.fsf@ti.com>
References: <1307392698-21170-1-git-send-email-ccross@android.com> <87boyav99n.fsf@ti.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 6 Jun 2011 19:06:36 -0600
X-Google-Sender-Auth: RiUK6JUOuyFaQlGRmujeKH-Gcv4
Message-ID: <BANLkTik-UK9EPsnUkQeih+Zf_9py-X2Q0A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ARM: omap4: gpio: fix setting IRQWAKEN bits
To: Kevin Hilman <khilman@ti.com>
Cc: Colin Cross <ccross@android.com>, linux-omap@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, tarun.kanti@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 5:18 PM, Kevin Hilman <khilman@ti.com> wrote:
> Hi Colin,
>
> Colin Cross <ccross@android.com> writes:
>
>> Setting the IRQWAKEN bit was overwriting previous IRQWAKEN bits,
>> causing only the last bit set to take effect, resulting in lost
>> wakeups when the GPIO controller is in idle.
>>
>> Replace direct writes to IRQWAKEN with MOD_REG_BIT calls to
>> perform a read-modify-write on the register.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>
> Thanks, I'll queue these both for Grant for the 3.0-rc fixes along with
> another GPIO fix for a section mismatch I have queued.
>
> Minor: now that this driver has moved to drivers, I changed the subject
> prefixes slightly.  They now read:
>
> GPIO: OMAP: fix setting IRQWAKEN bits for OMAP4
> GPIO: OMAP: add locking around calls to _set_gpio_triggering

If you're collecting fixes for Linus anyway, go ahead and add my a-b
line and include these two to send on to Linus

Acked-by: Grant Likely <grant.likely@secretlab.ca>

Or, if they are only gpio fixes, then I'd also be happy to get a git
pull req for the changes.  :-)

g.
