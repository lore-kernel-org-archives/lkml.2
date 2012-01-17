Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab2AQI62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:58:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51970 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab2AQI61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:58:27 -0500
Date: Tue, 17 Jan 2012 09:57:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Michael D Labriola <mlabriol@gdeb.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Kushal Koolwal <kushalkoolwal@gmail.com>, linux-kernel@vger.kernel.org,
        michael.d.labriola@gmail.com, support@versalogic.com,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: Re: Reboot hangs on VersaLogic Ocelot
Message-ID: <20120117085756.GB7612@elte.hu>
References: <OFE7865F25.43E4BFD2-ON85257984.0057CD12-85257984.0058D31D@gdeb.com>
 <20120116075348.GF15641@elte.hu>
 <OF8925048E.BDB4D255-ON85257987.005AFEB7-85257987.005C9188@LocalDomain>
 <OFFD8ED65D.E1B7CD3D-ON85257987.005EE0A9-85257987.005F48CD@gdeb.com>
 <20120116212938.GB6313@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116212938.GB6313@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Mon, Jan 16, 2012 at 12:20:45PM -0500, Michael D Labriola wrote:

> > Actually, assuming we fix the bios= argument ignored by DMI 
> > scan problem, would it be better to change the VersaLogic 
> > quirk to acpi even though it's not necessary right now?  If 
> > the default reboot method ever switches from acpi to kbd or 
> > bios, these boards will hang on reboot again...
> 
> A lot of hardware relies on the acpi method being used. I 
> don't see us changing the default for x86 when booted via 
> BIOS.

Yeah, i don't think we'll ever again switch away from ACPI being 
the default for currently existing hardware.

(Far-)future hardware might have different defaults, but that 
won't affect hardware that exists today.

Thanks,

	Ingo
