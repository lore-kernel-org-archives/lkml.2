Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab0GANyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:54:12 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54713 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab0GANyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:54:10 -0400
Date: Thu, 1 Jul 2010 14:54:01 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mattia Dongili <malattia@linux.it>, Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>, Andi Kleen <ak@linux.intel.com>,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] sony-laptop: use platform_device_unregister in
	sony_pf_remove
Message-ID: <20100701135401.GG31804@srcf.ucam.org>
References: <1277950681.30073.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277950681.30073.1.camel@mola>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 10:18:01AM +0800, Axel Lin wrote:
> platform_device_unregister calls platform_device_del and platform_device_put,
> thus this change is logically equivalent to original code.
> 
> I made this change because the documents in platform.c shows that:
> platform_device_del and platform_device_put must _only_ be externally called
> in error cases.  All other usage is a bug.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
