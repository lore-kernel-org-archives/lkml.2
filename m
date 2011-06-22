Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab1FVPuC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:50:02 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44133 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1FVPuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:50:01 -0400
Date: Wed, 22 Jun 2011 16:49:48 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 4/4] ACPI, APEI, Add APEI _OSC support
Message-ID: <20110622154948.GA3219@srcf.ucam.org>
References: <1308640587-24502-1-git-send-email-ying.huang@intel.com>
 <1308640587-24502-5-git-send-email-ying.huang@intel.com>
 <20110621132256.GB4902@srcf.ucam.org>
 <4E0151A0.90505@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0151A0.90505@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 10:21:20AM +0800, Huang Ying wrote:

> At least on some of my testing machine, generic _OSC call will not
> return any error even it does not support APEI bit.  So I think
> sometimes it may be helpful to printk something here.  To avoid
> confusion, can we change the message as follow.
> 
> - generic _OSC succeeded, APEI _OSC failed: APEI firmware first mode is
> enabled by APEI bit.
> - generic _OSC failed, APEI _OSC succeeded: APEI firmware first mode is
> enabled by APEI _OSC.

"WHEA _OSC", I think. The UUID here is part of the Microsoft spec, not 
the APEI one.

> - both succeeded: APEI firmware first mode is enabled by APEI bit and
> APEI _OSC.
> - both failed: Failed to enable APEI firmware first mode!

Otherwise, looks good.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
