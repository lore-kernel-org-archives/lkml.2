Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab2GDMmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 08:42:33 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34894 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab2GDMmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 08:42:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120703112828.GA28294@somewhere>
References: <CAJRGBZw_my_=Z+Jyb2UBYwW48BpCGYdcuD5mu7erHsX8NSKbDg@mail.gmail.com>
	<20120703112828.GA28294@somewhere>
Date: Wed, 4 Jul 2012 20:42:29 +0800
Message-ID: <CAJRGBZzn66mpQo+PCQirzqE=Wdm9T7Z01P20FQsHQnTPEd2mqA@mail.gmail.com>
Subject: Re: CPU isolation question again
From: Luming Yu <luming.yu@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gilad@benyossef.com,
        Len Brown <lenb@kernel.org>, shli@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 7:28 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Jun 27, 2012 at 09:22:09PM +0800, Luming Yu wrote:
>> Hi there,
>>
>> I noticed some discussion about CPU isolation which points me to the
>> patch set (https://lkml.org/lkml/2011/8/15/245). I'm currently
>> preparing a RFC-patch-set to automatically pick up a few suitable CPUs
>> to isolate then kick them out of service for a while. We need to
>> balance between  thermal & power management And overall system
>> performance during this operation as much as possible. So
>> software-cpu-online-offline interface could not be a good option to
>> me. But to make sure I'm not blindly running on a dead-end path, I'd
>> check with experts here to ensure it makes some sense to isolate CPUs
>> to this level, and the idea also makes some sense, and the most
>> important is it's not implemented yet.
>
> I don't understand what you are trying to do and how exactly. How do you
> plan to do this isolation and how do you want to balance between thermal
> and power?

My question could be wrong as the question arose several weeks ago
when I came across
 drivers/acpi/acpi_paid.c which looks like a real user who need to
request system automatically
pick up a few CPU to get them isolated and deactivated. Later on, I
noticed tglx's cpu hot plug re-work.
I realized we could reuse the interface to do isolation and deactivation work.

Of cause, to pick up which ones to isolate and deactivate is another problem.

cc'ed the author and ACPI maintainer of the driver as well as tglx.

thanks!
