Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab1KVQk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:40:27 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37477 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab1KVQk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:40:26 -0500
MIME-Version: 1.0
In-Reply-To: <86zkfpgxcx.fsf@sumi.keithp.com>
References: <s5hlirgm1kg.wl%tiwai@suse.de>
	<yunsjlnl1f6.fsf@aiko.keithp.com>
	<s5hlirelndd.wl%tiwai@suse.de>
	<861ut5mdvn.fsf@sumi.keithp.com>
	<s5hr5144ecu.wl%tiwai@suse.de>
	<867h2wklln.fsf@sumi.keithp.com>
	<s5hd3cn3unp.wl%tiwai@suse.de>
	<86zkfpgxcx.fsf@sumi.keithp.com>
Date: Tue, 22 Nov 2011 17:40:25 +0100
Message-ID: <CACTFLAOyA1XiPxstviwfbjAuTXSpKq-CEJ5FBRtFDhaKb8yk1A@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Fix invalid backpanel values for GEN3 or older chips
From: Daniel Mack <zonque@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: Takashi Iwai <tiwai@suse.de>, Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, harald@redhat.com,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 7:10 PM, Keith Packard <keithp@keithp.com> wrote:
> On Sun, 20 Nov 2011 12:22:50 +0100, Takashi Iwai <tiwai@suse.de> wrote:
>
>> So, writing bit-0 caused a problem, as it seems.
>
> Thanks. I've noted that in the patch message.

Just curious - is this patch queued somewhere for mainline yet?


Thanks,
Daniel
