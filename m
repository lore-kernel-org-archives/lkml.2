Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385Ab1FWNkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:40:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:32913 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326Ab1FWNkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:40:07 -0400
Date: Thu, 23 Jun 2011 14:39:50 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Stefan Assmann <sassmann@kpanic.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tony.luck@intel.com, andi@firstfloor.org,
        mingo@elte.hu, hpa@zytor.com, rick@vanrein.org, rdunlap@xenotime.net
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Message-ID: <20110623133950.GB28333@srcf.ucam.org>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 01:18:51PM +0200, Stefan Assmann wrote:
> Following the RFC for the BadRAM feature here's the updated version with
> spelling fixes, thanks go to Randy Dunlap. Also the code is now less verbose,
> as requested by Andi Kleen.
> v2 with even more spelling fixes suggested by Randy.
> Patches are against vanilla 2.6.39.
> Repost with LKML in Cc as suggested by Andrew Morton.

Would it be more reasonable to do this in the bootloader? You'd ideally 
want this to be done as early as possible in order to avoid awkward 
situations like your ramdisk ending up in the bad RAM area.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
