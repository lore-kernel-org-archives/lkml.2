Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab2KENLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:11:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52807 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2KENLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:11:04 -0500
MIME-Version: 1.0
In-Reply-To: <6279158.LZAthHxtvS@vostro.rjw.lan>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
	<CACRpkdYGbNCzV7QOURcEzhrNWv=kbWq+r3i66GtC75Aytso5rw@mail.gmail.com>
	<5097AD9D.7060808@linux.intel.com>
	<6279158.LZAthHxtvS@vostro.rjw.lan>
Date: Mon, 5 Nov 2012 14:11:03 +0100
Message-ID: <CACRpkdb6-YsyiSYoJb+Jea_9NPGe+8Nqy1hkCk=Mjki26S3-Zw@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpio / ACPI: add ACPI support
From: Linus Walleij <linus.walleij@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 1:46 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, November 05, 2012 02:14:21 PM Mathias Nyman wrote:

>> per-chip based numbering sounds saner, but this deals with what we
>> currently have.
>
> And we need something to hook up drivers to right now.

So speaking of it I have these drivers consuming pinctrl that I need
to hook up right now and the subsystem maintainers are NACKing
the patches because they want a centralized solution instead of
per-driver hooks and I get the red light...

Do you think they will change their mind and give me green light if
I tell them I just need to do it right now? ;-)

I suggest to take it easy and prolong the deadline, but none of
my business primarily, you will have to go through Grant who is
probably way more reasonable than me.

Yours,
Linus Walleij
