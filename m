Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967936Ab2ERJpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:45:07 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64820 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967112Ab2ERJpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:45:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1205180950400.3231@ionos>
References: <CAH3Oq6Rhqr+cZmYPCOhHqOP=B60zw_GRFDCkOTjEr9wp9NtFmA@mail.gmail.com>
	<alpine.LFD.2.02.1205180950400.3231@ionos>
Date: Fri, 18 May 2012 17:45:04 +0800
Message-ID: <CAH3Oq6SLf7zYoyrD8gvAZoaJTSEYvd2WHVo7_tc-Jj1o7MSAWw@mail.gmail.com>
Subject: Re: add IRQS_PENDING for nested, simple and level handler to early
 abort suspend operation
From: Ning Jiang <ning.n.jiang@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry that I didn't notice the patch in tip/irq/core. It did exactly
what I want. Forget about my patch. One more question: Do we need to
change handle_simple_irq and handle_nested_irq too?

Thanks,
Ning
