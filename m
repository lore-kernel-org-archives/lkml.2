Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0KVNgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:36:46 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:49969 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587Ab0KVNgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:36:44 -0500
Subject: Re: [PATCH 1/5] Backlight: Add backlight type
From: Richard Purdie <rpurdie@linux.intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org
In-Reply-To: <20101122123050.GA5385@srcf.ucam.org>
References: <1290182036-30484-1-git-send-email-mjg@redhat.com>
	 <20101119120523.15bc341c.akpm@linux-foundation.org>
	 <20101119202558.GA10898@srcf.ucam.org> <1290421020.1272.16707.camel@rex>
	 <20101122123050.GA5385@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 13:35:48 +0000
Message-ID: <1290432949.1272.16768.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 12:30 +0000, Matthew Garrett wrote:
> On Mon, Nov 22, 2010 at 10:17:00AM +0000, Richard Purdie wrote:
> 
> > I also want to make sure you think this patch is going to scale with
> > multiple GPU output machines? Thats the main reason I've held off any
> > patch like this as it doesn't help solve that problem as far as I can
> > tell. Yes, we have the device parent information and I see later in the
> > patch series you ensure the backlight is registered against the
> > connector which is good. If you have an ACPI "firmware" control that you
> > say should always be preferred, how do we know which connector device
> > that corresponds to in the multiple output case? From that point of view
> > this model falls apart?
> 
> The ACPI device will point at the correct PCI device. Associating it 
> with the appropriate connector is theoretically possible in the case of 
> open drivers, but I hadn't seen it as a high priority since (in 
> practice) there's no situations where an ACPI interface will be able to 
> control more than one backlight.

Its the reverse situation I worry about. Are there situations where
there are multiple connectors on the PCI device and the ACPI interface
just controls one of them but controls for the other connectors may
exist?

I'm typing this with an external monitor plugged into my laptop with
i915 graphics...

Cheers,

Richard





