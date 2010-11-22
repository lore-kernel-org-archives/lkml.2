Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab0KVMbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 07:31:00 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:36730 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab0KVMa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 07:30:59 -0500
Date: Mon, 22 Nov 2010 12:30:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Richard Purdie <rpurdie@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org
Subject: Re: [PATCH 1/5] Backlight: Add backlight type
Message-ID: <20101122123050.GA5385@srcf.ucam.org>
References: <1290182036-30484-1-git-send-email-mjg@redhat.com> <20101119120523.15bc341c.akpm@linux-foundation.org> <20101119202558.GA10898@srcf.ucam.org> <1290421020.1272.16707.camel@rex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290421020.1272.16707.camel@rex>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 10:17:00AM +0000, Richard Purdie wrote:

> I also want to make sure you think this patch is going to scale with
> multiple GPU output machines? Thats the main reason I've held off any
> patch like this as it doesn't help solve that problem as far as I can
> tell. Yes, we have the device parent information and I see later in the
> patch series you ensure the backlight is registered against the
> connector which is good. If you have an ACPI "firmware" control that you
> say should always be preferred, how do we know which connector device
> that corresponds to in the multiple output case? From that point of view
> this model falls apart?

The ACPI device will point at the correct PCI device. Associating it 
with the appropriate connector is theoretically possible in the case of 
open drivers, but I hadn't seen it as a high priority since (in 
practice) there's no situations where an ACPI interface will be able to 
control more than one backlight.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
