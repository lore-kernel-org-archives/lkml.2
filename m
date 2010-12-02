Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab0LBPYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 10:24:19 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58167 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab0LBPYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 10:24:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=VBjpZuNHstdcw3g2PBzS8PzhKp5xpCqUWtDcZ8vrszyg5rihLphJPyBDOvTRS4bcF+
         GJ7rXKbmUW4ac9rTJgHzz4wUA36B7MUvs68HKHWNN6qMgt+BZ8TzUlJvwHaZGQ7BnOXf
         DqT0OWY4odq/ev4J9aQ9NGoMaCuDINxEIW7MM=
MIME-Version: 1.0
In-Reply-To: <20101130221615.GA9424@n2100.arm.linux.org.uk>
References: <20101130173105.GA26929@oksana.dev.rtsoft.ru>
	<20101130221615.GA9424@n2100.arm.linux.org.uk>
Date: Thu, 2 Dec 2010 15:24:16 +0000
X-Google-Sender-Auth: nYip0PpNYaUeIaRziXpKLacbxos
Message-ID: <AANLkTinse2AS4gj0-5H3tZsXbhzW1AT8xY8gT9qo8j35@mail.gmail.com>
Subject: Re: [PATCH] ARM: TWD: Consolidate local timers support
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Anton Vorontsov <avorontsov@mvista.com>, Paul Walmsley <paul@pwsan.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Benoit Cousson <b-cousson@ti.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>, Varun Swara <Varun.Swara@arm.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 November 2010 22:16, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Nov 30, 2010 at 08:31:05PM +0300, Anton Vorontsov wrote:
>> This greatly reduces amount of platform-specific code, and thus
>> makes it easier to add local timers for new platforms.
>>
>> Technically, it's not very nice to place machine-specific (i.e.
>> local_timer_setup()) routine into the machine-agnostic code.
>> But the true thing is: currently all machines want the same thing.
>
> I've just been talking to someone this week about (presumably) non-TWD
> local timers.

FYI, Cortex-A15 comes with some architected timers different from the
current ones (specs publicly available in the same place as LPAE).
We'll push some patches at some point.

-- 
Catalin
