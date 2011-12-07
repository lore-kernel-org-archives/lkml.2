Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1LGIVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:21:16 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39110 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab1LGIVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:21:15 -0500
Date: Wed, 7 Dec 2011 10:21:08 +0200
From: Ido Yariv <ido@wizery.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] genirq: Flush the irq thread on synchronization
Message-ID: <20111207082108.GB1573@WorkStation>
References: <1322843052-7166-1-git-send-email-ido@wizery.com>
 <alpine.LFD.2.02.1112022345300.2735@ionos>
 <alpine.LFD.2.02.1112052248010.2735@ionos>
 <20111206232824.GA23893@WorkStation>
 <alpine.LFD.2.02.1112070140340.2735@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1112070140340.2735@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Wed, Dec 07, 2011 at 01:48:30AM +0100, Thomas Gleixner wrote:
> It's the only solution which actually solves the thread_active leak,

I think a thread regarding this issue was missed:
https://lkml.org/lkml/2011/12/4/113

Thanks,
Ido.
