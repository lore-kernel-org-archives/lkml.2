Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab0E3Gza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 02:55:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47752 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab0E3Gz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 02:55:29 -0400
Date: Sun, 30 May 2010 08:55:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: TAMUKI Shoichi <tamuki@linet.gr.jp>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>, Andy Green <andy@warmcat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic: keep blinking in spite of long spin timer mode
Message-ID: <20100530065522.GA14556@basil.fritz.box>
References: <20100528091354.GA16587@basil.fritz.box> <201005282211.AA00413@tamuki.linet.gr.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005282211.AA00413@tamuki.linet.gr.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Therefore, I changed to call panic_blink_enter() between every mdelay.
> The default time calls to mdelay is 1ms.  If the kernel parameter
> panic_longspin is set to true, it will be switched to 240ms and the
> maximum speed of blinking will be automatically limited slower due to
> the granularity of the blinking time.

Thanks for this explanation, makes all sense. 
But should do these changes by default then, not with a parameter.

Changing the frequency is ok, the only requirement is that it is
visible and different from the frequency kdb uses.

-Andi
