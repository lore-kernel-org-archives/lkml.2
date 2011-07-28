Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab1G1Q1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 12:27:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:49774 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab1G1Q13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 12:27:29 -0400
Date: Thu, 28 Jul 2011 18:27:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lars Segerlund <lars.segerlund@gmail.com>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt4 , Follow up question
In-Reply-To: <CAF-VNapwgfr66ib9OPcpJO-4K+6F-0VZA2Tc=4Fp==TDPKwkRQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1107281253451.2660@ionos>
References: <CAF-VNapwgfr66ib9OPcpJO-4K+6F-0VZA2Tc=4Fp==TDPKwkRQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jul 2011, Lars Segerlund wrote:
> How much is there left to do for mainline inclusion ?
> 
> A rough guess would be nice, just to assess the amount of work and severity.

  http://dilbert.com/strips/comic/2010-06-26/

If that doesn't answer your question, then you might try:

   # tar -xjf patches-3.0-rtx.tar.bz2
   # ls patches/*.patch
   # wc -l patches/*.patch
   # for each patch in patches; do read $patch; done

> As I understand it , a lot of subsystes are trying to go lockless, so
> things should become easier.

Not really, they just use different mechanisms. Serialization and
synchronization are not restricted to locks and some of these
mechanisms are even more evil than a plain old lock.

Thanks,

	tglx
