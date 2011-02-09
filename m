Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab1BIBFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 20:05:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755036Ab1BIBFY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 20:05:24 -0500
MIME-Version: 1.0
In-Reply-To: <201102090137.52697.rjw@sisk.pl>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <201102082220.25240.rjw@sisk.pl> <AANLkTinAZphXC=7FParFnxDPQvpB1ic=FwTe7u4Txy5o@mail.gmail.com>
 <201102090137.52697.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 Feb 2011 17:04:31 -0800
Message-ID: <AANLkTinZrhOdxZ-F+V1KLbR__PMNj-Qfc_O-xk7rJb_Y@mail.gmail.com>
Subject: Re: [PATCH 1/5] ACPI / PM: Move references to pm_flags into sleep.c
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 4:37 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
>> but maybe it would be about APM being enabled. Which is what the caller
>> actually seems to care about and talks about for the failure case. Maybe
>> you need separate functions for the "is APM enabled" case for the naming
>> to make sense. Hmm?
>
> That sounds like a good idea.  What about the following patch?

This patch I have no problems with.

                    Linus
