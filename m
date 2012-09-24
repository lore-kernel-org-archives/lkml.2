Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab2IXS0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:26:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49815 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247Ab2IXS0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:26:32 -0400
Date: Mon, 24 Sep 2012 19:26:15 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>, hpa@zytor.com, initramfs@vger.kernel.org,
        robert.moore@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, yinghai@kernel.org,
        eric.piel@tremplin-utc.net, vojcek@tlen.pl
Subject: Re: [PATCH 2/2] ACPI: Override arbitrary ACPI tables via initrd
 for debugging
Message-ID: <20120924182615.GA19227@srcf.ucam.org>
References: <1348234085-39220-1-git-send-email-trenn@suse.de>
 <1348234085-39220-3-git-send-email-trenn@suse.de>
 <505DD65F.9080203@kernel.org>
 <201209230317.04050.trenn@suse.de>
 <505E8F44.9020208@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505E8F44.9020208@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2012 at 12:25:40AM -0400, Len Brown wrote:
> > +config ACPI_INITRD_TABLE_OVERRIDE
> > +       bool
> > +       default y
> 
> Do distros in addition to SuSE concur they want to ship this way?

We certainly don't.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
