Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab2APVaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:30:04 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54044 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab2APVaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:30:01 -0500
Date: Mon, 16 Jan 2012 21:29:38 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Michael D Labriola <mlabriol@gdeb.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Kushal Koolwal <kushalkoolwal@gmail.com>, linux-kernel@vger.kernel.org,
        michael.d.labriola@gmail.com, support@versalogic.com,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: Re: Reboot hangs on VersaLogic Ocelot
Message-ID: <20120116212938.GB6313@srcf.ucam.org>
References: <OFE7865F25.43E4BFD2-ON85257984.0057CD12-85257984.0058D31D@gdeb.com>
 <20120116075348.GF15641@elte.hu>
 <OF8925048E.BDB4D255-ON85257987.005AFEB7-85257987.005C9188@LocalDomain>
 <OFFD8ED65D.E1B7CD3D-ON85257987.005EE0A9-85257987.005F48CD@gdeb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFFD8ED65D.E1B7CD3D-ON85257987.005EE0A9-85257987.005F48CD@gdeb.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 12:20:45PM -0500, Michael D Labriola wrote:
> Actually, assuming we fix the bios= argument ignored by DMI scan problem, 
> would it be better to change the VersaLogic quirk to acpi even though it's 
> not necessary right now?  If the default reboot method ever switches from 
> acpi to kbd or bios, these boards will hang on reboot again...

A lot of hardware relies on the acpi method being used. I don't see us 
changing the default for x86 when booted via BIOS.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
