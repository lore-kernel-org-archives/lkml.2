Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1C3KgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:36:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59611 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab1C3KgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:36:02 -0400
Date: Wed, 30 Mar 2011 11:35:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@linux.intel.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] GMA500 updates
Message-ID: <20110330103556.GB29796@srcf.ucam.org>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 09:58:57AM +0100, Alan Cox wrote:
> This set of patches tackles three basic things
> 
> - Add support for Moorestown (not yet usable as it needs a memory allocator)

Is Moorestown known as GMA500 or GMA600? Is there some more generic name 
that would cover all of them?

(Clearly not a high-priority issue, given the set of hardware supported 
by the i915 driver)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
