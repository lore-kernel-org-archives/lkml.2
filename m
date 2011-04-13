Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab1DMOUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:20:11 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:64769 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab1DMOUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:20:07 -0400
Subject: Re: [PATCH 1/2] avr32: At32ap: fix extint irq_chip type from
 irq_chip to irq_data
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>
In-Reply-To: <1302409040-13791-1-git-send-email-plagnioj@jcrosoft.com>
References: <1302409040-13791-1-git-send-email-plagnioj@jcrosoft.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Wed, 13 Apr 2011 14:59:56 +0200
Message-ID: <1302699596.22451.10.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Apr 2011 13:02:26.0922 (UTC) FILETIME=[09E30CA0:01CBF9DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-10 at 06:17 +0200, Jean-Christophe PLAGNIOL-VILLARD
wrote: 
> introduce in commit 7776e233ef
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Patrice Vilchez <patrice.vilchez@atmel.com>

Thanks, but seems like Andrew already pulled a similar fix [1] into the
-mm tree which I'll send through the AVR32 tree.

<snipp patch>

1: http://www.spinics.net/lists/mm-commits/msg83268.html

-- 
Hans-Christian Egtvedt

