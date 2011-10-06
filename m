Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab1JFRNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:13:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38281 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758657Ab1JFRNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:13:50 -0400
MIME-Version: 1.0
In-Reply-To: <yunpqiikeut.fsf@aiko.keithp.com>
References: <yunpqiikeut.fsf@aiko.keithp.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Oct 2011 10:12:57 -0700
X-Google-Sender-Auth: r-diD-SA_ZYv8qtXYWBTIhJn_2I
Message-ID: <CA+55aFzR91rOstOcAUoTXGHvztqG-aB-j37_p3F9C3-Ngc_6dQ@mail.gmail.com>
Subject: Re: [PULL] drm-intel-fixes (drm/i915 driver)
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 6:18 PM, Keith Packard <keithp@keithp.com> wrote:
>
> Here are three tiny patches, two new bug fixes and one regression fix
> that disables FBC on Ironlake and older chips.

So I got this error notice at bootup with the current -git tree.
Everything seems to work despite it, but I thought I'd mention it.

  [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH

This is a Lenovo X1.

                      Linus

---
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation
Core Processor Family Integrated Graphics Controller (rev 09) (prog-if
00 [VGA controller])
	Subsystem: Lenovo Device 21e8
	Flags: bus master, fast devsel, latency 0, IRQ 40
	Memory at f0000000 (64-bit, non-prefetchable) [size=4M]
	Memory at e0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at 5000 [size=64]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: <access denied>
	Kernel driver in use: i915
00: 86 80 26 01 07 04 90 00 09 00 00 03 00 00 00 00
10: 04 00 00 f0 00 00 00 00 0c 00 00 e0 00 00 00 00
20: 01 50 00 00 00 00 00 00 00 00 00 00 aa 17 e8 21
30: 00 00 00 00 90 00 00 00 00 00 00 00 0b 01 00 00
