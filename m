Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937Ab2EWTEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:04:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:46309 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933848Ab2EWTE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:04:28 -0400
Date: Wed, 23 May 2012 21:04:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ning Jiang <ning.n.jiang@gmail.com>
cc: rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: Add IRQS_PENDING for nested and simple irq handler as well
In-Reply-To: <CAH3Oq6QW-ku2EdCGrc9yHnYBdwYfNOkkCmgdpkq_d-FdrK-sng@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1205232102380.3231@ionos>
References: <CAH3Oq6T-OVj_=kVBdDXxize5v5hovp8FQSDhxCHvF_kcX4QPuA@mail.gmail.com> <alpine.LFD.2.02.1205212308590.3231@ionos> <CAH3Oq6S64c9ttsAStn05FTkg+VC0o27Ad4DhHs=b4E7AKjWdjA@mail.gmail.com> <alpine.LFD.2.02.1205221048140.3231@ionos>
 <CAH3Oq6T905+3fkF43NAMMFvJvq7dsk_so6T2vQ8ZJrA5xiU3YA@mail.gmail.com> <CAH3Oq6QW-ku2EdCGrc9yHnYBdwYfNOkkCmgdpkq_d-FdrK-sng@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012, Ning Jiang wrote:
> Hi Thomas,
> Is there any problem to merge this patch?

Yes, the problem is that I'm not a robot and that my day has a limited
number of work hours.
