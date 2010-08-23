Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab0HWRva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:51:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56462 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab0HWRv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:51:28 -0400
Date: Mon, 23 Aug 2010 18:51:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Renninger <trenn@suse.de>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de, jlee@novell.com, Dennis.Jansen@web.de,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] Add intel drm blacklist to intel_opregion_present
	detect
Message-ID: <20100823175118.GA28319@srcf.ucam.org>
References: <1282563648-21935-1-git-send-email-jlee@novell.com> <20100823114938.GA19879@srcf.ucam.org> <201008231953.22459.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008231953.22459.trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 07:53:21PM +0200, Thomas Renninger wrote:

> Hm, needing a module option to get a system running is not what the user expects.
> By default, the system should run fine and a module option should be added
> as a workaround or for debugging only.

How about we do this instead: add a psb stub driver that does nothing 
other than call acpi_backlight_register()?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
