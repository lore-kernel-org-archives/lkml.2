Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2AQWRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 17:17:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234Ab2AQWRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 17:17:12 -0500
Date: Tue, 17 Jan 2012 23:17:09 +0100
From: Holger Macht <hmacht@suse.de>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ACPI & Power Management Patches for 3.3
Message-ID: <20120117221709.GA10776@homac.suse.de>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326802902-21583-1-git-send-email-lenb@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di 17. Jan - 07:20:52, Len Brown wrote:
> These patches are queued for 3.3 in
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git next
> 
> Let me know if you have troubles with any of them.

Any specific reason why the patches regarding the dock station/libata
hotplug stuff (initially sent by Matthew Garrett, resent and extended by
me on 2011-12-06 [1]) are not considered? I know, they're spanning two
different subsystems, but one subsystem maintainer might need to take
the first step.

Thanks,
 Holger

[1] [Patch 0/7] acpi/libata: Express dependencies for devices on dock stations and bays
