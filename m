Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab0GANvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:51:13 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54608 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab0GANvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:51:11 -0400
Date: Thu, 1 Jul 2010 14:51:00 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Len Brown <len.brown@intel.com>, Thomas Renninger <trenn@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] wmi: fix a memory leak in wmi_notify_debug
Message-ID: <20100701135100.GB31804@srcf.ucam.org>
References: <1277688645.22992.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277688645.22992.2.camel@mola>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 09:30:45AM +0800, Axel Lin wrote:
> When acpi_evaluate_object() is passed ACPI_ALLOCATE_BUFFER,
> the caller must kfree the returned buffer if AE_OK is returned.
> 
> The callers of wmi_get_event_data() pass ACPI_ALLOCATE_BUFFER,
> and thus must check its return value before accessing
> or kfree() on the buffer.
> 
> This patch adds return value checking for wmi_get_event_data()
> and adds a missing kfree(obj) in the end of wmi_notify_debug

Applied, thanks.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
