Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab2GZReQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:34:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38143 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2GZReP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:34:15 -0400
Date: Thu, 26 Jul 2012 18:33:33 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mikew@google.com, tony.luck@intel.com,
        keescook@chromium.org, gong.chen@linux.intel.com, gregkh@suse.de,
        paul.gortmaker@windriver.com, maxin.john@gmail.com,
        rdunlap@xenotime.net, matt.fleming@intel.com, olof@lixom.net,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Shorten constant names for EFI variable attributes
Message-ID: <20120726173332.GA19851@srcf.ucam.org>
References: <20120720220841.GA32642@hp.com>
 <5009D770.1050905@zytor.com>
 <20120723132656.GC21495@srcf.ucam.org>
 <50117E40.8090904@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50117E40.8090904@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 11:28:32AM -0600, Khalid Aziz wrote:

> I also do not believe that kernel must use the constant names
> mentioned in the specification especially when the name reaches 50
> characters. We can not get away from having to create aliases. Do
> you think having aliases in efi.h can cause mixed use of long names
> and short names in future code in the kernel? Can we address this by
> suggesting to future code authors that they should use the short
> names in their code? Should we consider inclusion of this patch in
> the kernel?

I'd be surprised if it were a problem - we should catch any of those 
cases in code review, or gate the aliases under #ifndef __KERNEL__

-- 
Matthew Garrett | mjg59@srcf.ucam.org
