Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab1DMNRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:17:53 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:46090 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab1DMNRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:17:52 -0400
Subject: Re: [PATCH] avr32: fix deadlock when reading clock list in debugfs
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Ole Henrik Jahren <olehenja@alumni.ntnu.no>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110306194239.GA9342@siv.localdomain>
References: <20110306194239.GA9342@siv.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Wed, 13 Apr 2011 15:17:45 +0200
Message-ID: <1302700665.10549.4.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Apr 2011 13:17:47.0549 (UTC) FILETIME=[2E9F94D0:01CBF9DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-06 at 20:42 +0100, Ole Henrik Jahren wrote: 
> When writing out /sys/kernel/debug/at32ap_clk, clock list lock is being
> held while clk_get() is called. clk_get() attempts to take the same
> lock, which results in deadlock. Introduce and call lock free version,
> __clk_get(), instead.
> 
> Signed-off-by: Ole Henrik Jahren <olehenja@alumni.ntnu.no>
> Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

Thanks for this fix, added to the AVR32 tree.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

<snipp patch>

-- 
Hans-Christian Egtvedt

