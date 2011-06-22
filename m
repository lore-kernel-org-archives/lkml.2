Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab1FVTnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:43:00 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52503 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550Ab1FVTm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:42:59 -0400
Date: Wed, 22 Jun 2011 20:42:55 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Chubb <peter.chubb@nicta.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Acer Aspire One now hangs on reboot/shutdown
Message-ID: <20110622194254.GC8861@srcf.ucam.org>
References: <w4oc1qp2wf.wl%peter@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w4oc1qp2wf.wl%peter@chubb.wattle.id.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 08:38:08PM +1000, Peter Chubb wrote:

>    I printed out the FADT bits that were relevant---it claims revision 4
>    in the header, and the ACPI_FADT_RESET_REGISTER bit is set in the
>    flags.  The values of the reset register's address and width look
>    reasonable (address 3321 in IO space, width 8 offset 0)

Irritating. Ok, let's see if we can figure this out. Can you put the 
system's acpidump output somewhere? Also, if you boot with 
init=/bin/bash, what does writing the FADT reset value to 3321 do?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
