Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab0DCRKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 13:10:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49328 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0DCRKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 13:10:24 -0400
Date: Sat, 3 Apr 2010 18:10:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] laptop-mode: Make flushes per-device
Message-ID: <20100403171022.GB11397@srcf.ucam.org>
References: <20091214195806.GV8742@kernel.dk> <1260901295-1821-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260901295-1821-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 01:21:35PM -0500, Matthew Garrett wrote:
> One of the features of laptop-mode is that it forces a writeout of dirty
> pages if something else triggers a physical read or write from a device.
> The current implementation flushes pages on all devices, rather than only
> the one that triggered the flush. This patch alters the behaviour so that
> only the recently accessed block device is flushed, preventing other
> disks being spun up for no terribly good reason.

Hi Jens,

Can you remember if there were any more issues with this, or can this 
version be merged now?

Thanks,
-- 
Matthew Garrett | mjg59@srcf.ucam.org
