Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab1DLP7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:59:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41405 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883Ab1DLP7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:59:34 -0400
Date: Tue, 12 Apr 2011 16:59:21 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com,
        Robert Hancock <hancockrwd@gmail.com>, lenb@kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
Message-ID: <20110412155921.GA531@srcf.ucam.org>
References: <4C87A62E.30108@gmail.com>
 <1302598086-3622-1-git-send-email-jslaby@suse.cz>
 <20110412085622.43488ed9@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412085622.43488ed9@jbarnes-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 08:56:22AM -0700, Jesse Barnes wrote:

> I'll defer to the ACPI experts, Len or Matthew have you checked this
> one out?

Windows appears to work without this, so it seems likely that we're 
doing something wrong in some other sense, but I don't think we have a 
good idea as to what we're doing wrong...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
