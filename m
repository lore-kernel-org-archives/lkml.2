Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab2GTOdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 10:33:01 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35124 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab2GTOdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 10:33:00 -0400
Date: Fri, 20 Jul 2012 16:32:47 +0200
From: Anisse Astier <anisse@astier.eu>
To: Alan Cox <alan@linux.intel.com>
Cc: Josh Boyer <jwboyer@redhat.com>, kernel-team@fedoraproject.org,
        Dave Airlie <airlied@redhat.com>, dkline@redhat.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: gma500 opregion/power init order backtrace
Message-ID: <20120720163247.19578db4@destiny.ordissimo>
In-Reply-To: <20120717221242.315f8dfe@bob.linux.org.uk>
References: <20120717192614.GB18229@zod.bos.redhat.com>
	<20120717221242.315f8dfe@bob.linux.org.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012 22:12:42 +0100, Alan Cox <alan@linux.intel.com> wrote :

> > I'm wondering if the gma_power_init call can be moved up before
> > chip_setup is called.  Seems so, but I thought I would ping you to see
> > if you've seen this already.
> 
> Fixed in the patches that went to Linus.
Thanks for this ! I was having this 100 scale brightness issue on anther
hardware.

> 
> I don't have the ACPI backlight working on a lot of systems and don't
> know why to be honest but the native backlight should work. Of course if
> the acpi keys are plumbed into the ACPI backlight it's less useful 8)

Can't we just "wire" this to psb-bl in the driver ? There are a few
drivers in drivers/platform/x86 already sending KEY_BRIGHTNESS{UP,DOWN}
keycodes.

Regards,

Anisse

