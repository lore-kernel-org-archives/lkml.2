Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab2AESRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:17:33 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:48183 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2AESRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:17:32 -0500
Date: Thu, 5 Jan 2012 18:17:24 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Olof Johansson <olof@lixom.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 1/5] x86: efi: refactor efi_init() a bit
Message-ID: <20120105181723.GA24242@srcf.ucam.org>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
 <1325610682-24811-2-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325610682-24811-2-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 09:11:18AM -0800, Olof Johansson wrote:

>  	if (memmap.desc_size != sizeof(efi_memory_desc_t))
> -		printk(KERN_WARNING
> -		  "Kernel-defined memdesc doesn't match the one from EFI!\n");
> +		printk(KERN_WARNING "Kernel-defined memdesc doesn't match the "
> +		       "one from EFI!\n");

Just kill this - it's valid per-spec, there's no reason for us to 
complain.

Looks fine otherwise.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
