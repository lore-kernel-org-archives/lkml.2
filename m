Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2D3HG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 03:06:27 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57482 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab2D3HG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 03:06:26 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-97-4f9e39f009ee
Message-ID: <4F9E39F1.5030600@kernel.org>
Date: Mon, 30 Apr 2012 16:06:25 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: vmevent: question?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Pekka,

I looked into vmevent and have few questions.

vmevent_smaple gathers all registered values to report to user if vmevent match.
But the time gap between vmevent match check and vmevent_sample_attr could make error
so user could confuse.

Q 1. Why do we report _all_ registered vmstat value?
     In my opinion, it's okay just to report _a_ value vmevent_match happens.
Q 2. Is it okay although value when vmevent_match check happens is different with
     vmevent_sample_attr in vmevent_sample's for loop?
     I think it's not good.
Q 3. Do you have any plan to change getting value's method?
     Now it's IRQ context so we have limitation to get a vmstat values so that
     It couldn't be generic. IMHO, To merge into mainline, we should solve this problem.
Q 4. Do you have any plan for this patchset to merge into mainline?

Thanks.

-- 
Kind regards,
Minchan Kim
