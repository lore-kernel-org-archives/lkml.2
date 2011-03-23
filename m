Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab1CWK7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:59:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47866 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab1CWK7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:59:14 -0400
Date: Wed, 23 Mar 2011 10:59:06 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 4/4] ACPI: Make sure the FADT is at least rev 2 before
	using the reset register
Message-ID: <20110323105906.GA29657@srcf.ucam.org>
References: <1299877940-6870-1-git-send-email-mjg@redhat.com> <1299877940-6870-4-git-send-email-mjg@redhat.com> <alpine.LFD.2.02.1103222354150.10549@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1103222354150.10549@x980>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 12:01:50AM -0400, Len Brown wrote:
>         if (!(acpi_gbl_FADT.flags & ACPI_FADT_RESET_REGISTER))
>                 return;
> 
> For it not to be redundant, there would have to be FADTs out there
> of revision 1 that set what was then a reserved bit in the flags.

Yes. You trust them not to have set reserved flags to random garbage?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
