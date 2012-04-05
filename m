Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2DEWKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:10:30 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:58773 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab2DEWK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:10:29 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use irq_alloc_desc() instead
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
	<1329383368-12122-7-git-send-email-grant.likely@secretlab.ca>
	<m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home>
	<20120402202848.1EB833E02A7@localhost> <m2y5qdow0v.fsf@igel.home>
	<20120404154020.40C513E09D5@localhost>
X-Yow: How many retired bricklayers from FLORIDA are out purchasing
 PENCIL SHARPENERS right NOW??
Date: Fri, 06 Apr 2012 00:10:23 +0200
In-Reply-To: <20120404154020.40C513E09D5@localhost> (Grant Likely's message of
	"Wed, 04 Apr 2012 08:40:20 -0700")
Message-ID: <m2r4w1akz4.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely <grant.likely@secretlab.ca> writes:

> Can you attach console output logs for each of configs above and also
> with NR_IRQS=128?  That might give me some clues as to which specific
> code is causing the issues.

It really looks like the issue starts when irq_expand_nr_irqs is called
the first time to make nr_irqs bigger than NR_IRQS.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
