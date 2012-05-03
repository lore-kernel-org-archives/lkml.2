Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2ECG7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:59:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58180 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2ECG7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:59:36 -0400
Message-ID: <4FA22CC5.3010107@gmail.com>
Date: Thu, 03 May 2012 14:59:17 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: use local var instead of local_paca->irq_happened
 directly in __check_irq_replay
References: <4FA1E527.1090807@gmail.com> <1336011306.2653.3.camel@pasglop> <1336018961.2653.11.camel@pasglop> <4FA226A8.1080903@gmail.com>
In-Reply-To: <4FA226A8.1080903@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012年05月03日 14:33, Wang Sheng-Hui wrote:
> if (unlikely(irq_happened != PACA_IRQ_HARD_DIS))
>> 		__hard_irq_disable();

I have commented out the 2 lines.

FYI.

thanks,
