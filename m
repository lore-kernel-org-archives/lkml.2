Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab0GANxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:53:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54641 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab0GANxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:53:20 -0400
Date: Thu, 1 Jul 2010 14:53:11 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>, Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       acpi4asus-user@lists.sourceforge.net,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] asus-laptop: fix a memory leak in asus_laptop_get_info
	error path
Message-ID: <20100701135311.GC31804@srcf.ucam.org>
References: <1277780987.5478.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277780987.5478.2.camel@mola>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 11:09:47AM +0800, Axel Lin wrote:
> The callers of write_acpi_int_ret() pass ACPI_ALLOCATE_BUFFER,
> the caller must kfree the returned buffer if AE_OK is returned.
> 
> This patch adds a missing kfree(buffer.pointer) before return -ENOMEM
> if kstrdup fail.

Applied, thanks.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
