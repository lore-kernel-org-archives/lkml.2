Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2AQPYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:24:22 -0500
Received: from mx2.gd-ms.com ([153.11.250.41]:57215 "EHLO mx2.gd-ms.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab2AQPYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:24:21 -0500
In-Reply-To: <OFE7567546.E048E2ED-ON85257988.004E1300-85257988.004EF54C@LocalDomain>
References: <OFE7865F25.43E4BFD2-ON85257984.0057CD12-85257984.0058D31D@gdeb.com> <20120116075348.GF15641@elte.hu> <OF8925048E.BDB4D255-ON85257987.005AFEB7-85257987.005C9188@LocalDomain> <OFFD8ED65D.E1B7CD3D-ON85257987.005EE0A9-85257987.005F48CD@gdeb.com> <20120116212938.GB6313@srcf.ucam.org> <20120117085756.GB7612@elte.hu> <OFE7567546.E048E2ED-ON85257988.004E1300-85257988.004EF54C@LocalDomain>
To: Michael D Labriola <mlabriol@gdeb.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Kushal Koolwal <kushalkoolwal@gmail.com>, linux-kernel@vger.kernel.org,
        michael.d.labriola@gmail.com, Matthew Garrett <mjg59@srcf.ucam.org>,
        support@versalogic.com, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
MIME-Version: 1.0
Subject: Re: Reboot hangs on VersaLogic Ocelot
X-KeepSent: A8FD2B04:C1CDB53C-85257988:0054783B;
 type=4; name=$KeepSent
Message-ID: <OFA8FD2B04.C1CDB53C-ON85257988.0054783B-85257988.00549E58@gdeb.com>
From: Michael D Labriola <mlabriol@gdeb.com>
Date: Tue, 17 Jan 2012 10:24:15 -0500
X-GDMEncrypt: FALSE
X-GDMMarking: NOT_SENSITIVE
Content-Type: text/plain; charset="US-ASCII"
X-GDM-MESSAGE-ID: X-GDM-MESSAGE-ID mx2.gd-ms.com 1RnAtV-0007pS-Gp
X-GDM-EVAL: score: /30; hits: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael D Labriola/EB/GDYN wrote on 01/17/2012 09:22:25 AM:

> From: Michael D Labriola/EB/GDYN
> To: Ingo Molnar <mingo@elte.hu>
> Cc: "H. Peter Anvin" <hpa@zytor.com>, Kushal Koolwal 
> <kushalkoolwal@gmail.com>, linux-kernel@vger.kernel.org, 
> michael.d.labriola@gmail.com, Matthew Garrett <mjg59@srcf.ucam.org>,
> support@versalogic.com, Thomas Gleixner <tglx@linutronix.de>, 
x86@kernel.org
> Date: 01/17/2012 09:22 AM
> Subject: Re: Reboot hangs on VersaLogic Ocelot
> 
> Ingo Molnar <mingo@elte.hu> wrote on 01/17/2012 03:57:56 AM:
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > To: Matthew Garrett <mjg59@srcf.ucam.org>
> > Cc: Michael D Labriola <mlabriol@gdeb.com>, "H. Peter Anvin" 
> > <hpa@zytor.com>, Kushal Koolwal <kushalkoolwal@gmail.com>, linux-
> > kernel@vger.kernel.org, michael.d.labriola@gmail.com, 
> > support@versalogic.com, Thomas Gleixner <tglx@linutronix.de>, 
x86@kernel.org
> > Date: 01/17/2012 04:04 AM
> > Subject: Re: Reboot hangs on VersaLogic Ocelot
> > 
> > 
> > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > 
> > > On Mon, Jan 16, 2012 at 12:20:45PM -0500, Michael D Labriola wrote:
> > 
> > > > Actually, assuming we fix the bios= argument ignored by DMI 
> > > > scan problem, would it be better to change the VersaLogic 
> > > > quirk to acpi even though it's not necessary right now?  If 
> > > > the default reboot method ever switches from acpi to kbd or 
> > > > bios, these boards will hang on reboot again...
> > > 
> > > A lot of hardware relies on the acpi method being used. I 
> > > don't see us changing the default for x86 when booted via 
> > > BIOS.
> > 
> > Yeah, i don't think we'll ever again switch away from ACPI being 
> > the default for currently existing hardware.
> > 
> > (Far-)future hardware might have different defaults, but that 
> > won't affect hardware that exists today.
> > 
> > Thanks,
> > 
> >    Ingo
> 
> Ingo,
> 
> I sent the aforementioned patches last night using git-send-email...
> but I'm not sure they went through correctly.  I got the email at my
> home account, but not my work account, and they don't seem to be in 
> the LKML archives.  Did anyone get them?  I listed all the addresses
> on this email's distro with separate --to and --cc arguments and 
> tried to use an appropriate In-Reply-To Message-Id when prompted, 
> but maybe I messed it up.
> 
> Also, how does the sign-off work?  Does the appropriate person 
> (Matthew?) review the patches and re-submit with a sign-off field?

OK, I've resent the patches from my work email (Lotus Notes! Fingers 
crossed!!).  New patches include sign-off from myself.

---
Michael D Labriola
Electric Boat
mlabriol@gdeb.com
401-848-8871 (desk)
401-848-8513 (lab)
401-316-9844 (cell)




 



