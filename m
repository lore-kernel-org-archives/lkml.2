Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1BFXGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:06:20 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58085 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab1BFXGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:06:08 -0500
Date: Sun, 6 Feb 2011 23:05:58 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: akpm@linux-foundation.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [PATCH 5/5] ACPI: Tie ACPI backlight devices to PCI devices if
	possible
Message-ID: <20110206230558.GA23889@srcf.ucam.org>
References: <1295033065-13450-1-git-send-email-mjg@redhat.com> <201102062341.19631.rjw@sisk.pl> <20110206225308.GA23557@srcf.ucam.org> <201102070001.25814.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102070001.25814.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 12:01:25AM +0100, Rafael J. Wysocki wrote:

> Yes, it seems so, but I'm not sure what the short term consequences of that
> change will be.  Perhaps there will be none. :-)

Ok, I'll have a play with that. Maybe we should be fixing this up 
somehow in the acpi-pci glue code? It seems wrong to have acpi devices 
resumed before the PCI device they're associated with.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
