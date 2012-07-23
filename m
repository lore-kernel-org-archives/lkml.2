Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2GWN1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 09:27:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57409 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2GWN1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 09:27:31 -0400
Date: Mon, 23 Jul 2012 14:26:56 +0100
From: Matthew Garrett <mjg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Khalid Aziz <khalid.aziz@hp.com>, mikew@google.com, tony.luck@intel.com,
        keescook@chromium.org, gong.chen@linux.intel.com, gregkh@suse.de,
        paul.gortmaker@windriver.com, maxin.john@gmail.com,
        rdunlap@xenotime.net, matt.fleming@intel.com, olof@lixom.net,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Shorten constant names for EFI variable attributes
Message-ID: <20120723132656.GC21495@srcf.ucam.org>
References: <20120720220841.GA32642@hp.com>
 <5009D770.1050905@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5009D770.1050905@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 03:10:56PM -0700, H. Peter Anvin wrote:
> On 07/20/2012 03:08 PM, Khalid Aziz wrote:
> >Replace very long constants for EFI variable attributes
> >with shorter and more convenient names. Also create an
> >alias for the current longer names so as to not break
> >compatibility with current API since these constants
> >are used by userspace programs. This patch depends on
> >patch <https://lkml.org/lkml/2012/7/13/313>.
> 
> I think these some from the EFI specifcation, so NAK IMO.

>From the point of view of making efivars more readable, I'd certainly 
prefer shorter constant names. Keeping an alias is necessary only 
because it's an existing exposed interface. The specification doesn't 
actually require the use of these specific names anywhere, and we've 
taken a more relaxed attitude in other bits of the EFI code.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
