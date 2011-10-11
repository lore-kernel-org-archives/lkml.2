Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab1JKHGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 03:06:10 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61235 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab1JKHGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 03:06:07 -0400
MIME-Version: 1.0
Date: Tue, 11 Oct 2011 09:06:06 +0200
Message-ID: <CAC9WiBhJCePE9=vB5=Jii10kXjnB67D97JFkBsxFMSD0qdWzLQ@mail.gmail.com>
Subject: 3.1-rc9: 2 ironlake crashes in the same day
From: Francis Moreau <francis.moro@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Yesterday I encountered 2 different video crashes that led to X being unusable.

Here's the log for the first one:

 [419692.139514] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
 [429557.280034] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
elapsed... GPU hung
 [429557.287415] [drm:init_ring_common] *ERROR* failed to set render
ring head to zero ctl 00000000 head 2100f39c tail 00000000 start
00001000
 [429557.287423] [drm:init_ring_common] *ERROR* render ring
initialization failed ctl 0001f003 head 2100f39c tail 00000000 start
00001000
 [429557.374977] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
 [429557.662980] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
 [429559.484115] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
elapsed... GPU hung
 [429559.484368] [drm:i915_reset] *ERROR* GPU hanging too fast,
declaring wedged!
 [429559.484374] [drm:i915_reset] *ERROR* Failed to reset chip.
 [429619.362973] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
 [429619.573296] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
 [429657.186958] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
 [429675.135961] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
 [429694.101906] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
 [   13.171255] intel ips 0000:00:1f.6: failed to get i915 symbols,
graphics turbo disabled

And here's the second log:


[   20.703141] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[21528.205341] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[21528.415574] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[21530.096757] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[21530.307944] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[21533.506178] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[21534.011096] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
invalid, remainder is 226
[21534.011099] Raw EDID:
[21534.011101]          00 ff ff ff ff ff ff 00 4c 2d 1b 07 30 32 30 30
[21534.011102]          2a 14 01 03 80 30 1b 78 2a 78 f1 a6 55 48 9b 26
[21534.011103]          12 50 54 bf ef 80 71 4f 81 00 81 40 81 80 95 00
[21534.011105]          95 0f a9 40 b3 00 02 3a 80 18 71 38 2d 40 58 2c
[21534.011106]          45 00 dd 0c 11 00 00 1e 01 1d ff ff ff ff ff ff
[21534.011107]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[21534.011108]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[21534.011110]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[21561.055845] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[21561.388017] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[21581.971189] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH

I think it worthed a report.

Thanks
-- 
Francis
