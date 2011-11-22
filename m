Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab1KVLk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:40:27 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33814 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab1KVLkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:40:25 -0500
MIME-Version: 1.0
X-Originating-IP: [93.173.4.235]
In-Reply-To: <874nywpfkd.fsf@rustcorp.com.au>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com> <874nywpfkd.fsf@rustcorp.com.au>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 22 Nov 2011 13:40:04 +0200
Message-ID: <CAK=WgbaF=yvGXvJdENrMoi4wWxaQa3UpbtsRm3mcA3cFdDCitA@mail.gmail.com>
Subject: Re: [PATCH 0/7] Introducing a generic AMP framework
To: Rusty Russell <rusty@rustcorp.com.au>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 6:00 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Tue, 25 Oct 2011 11:48:19 +0200, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>> Modern SoCs typically employ a central symmetric multiprocessing (SMP)
>> application processor running Linux, with several other asymmetric
>> multiprocessing (AMP) heterogeneous processors running different instances
>> of operating system, whether Linux or any other flavor of real-time OS.
>
> OK, I'm not even sure who this should go through

We shortly discussed this in ELCE, and this can either go through the
arm-soc tree or directly to Linus; however Arnd prefers really.

The previous RFC iteration was reviewed quite extensively (especially
by Grant. thanks Grant!) but I was hoping to get some more review or
feedback on this iteration as well (any form of Acked-by, Reviewed-by,
+1-by or No-way-by are welcome).

At this point I know of at least four vendors (besides TI) who are
actively looking into supporting this, and it's getting a bit hard to
collaborate, so I plan to get this into linux-next later this week
(minus the virtio-spec.txt change which I'll send directly to you,
Rusty) in the hope of getting this merged into 3.3.

>, but no objections here

Can I add your Acked-by on the virtio parts (mainly patches 3 and 6) ?

Thanks!
Ohad.
