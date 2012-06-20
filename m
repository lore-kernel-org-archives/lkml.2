Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab2FTGxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 02:53:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:47263 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab2FTGxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 02:53:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="182552078"
Message-ID: <1340175285.1682.26.camel@rui.sh.intel.com>
Subject: Re: thermal_zone trip_point_0_temp =?ISO-8859-1?Q?200=B0C?=
From: Zhang Rui <rui.zhang@intel.com>
To: Mark <markieb.lists.20090330@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org
Date: Wed, 20 Jun 2012 14:54:45 +0800
In-Reply-To: <4FDB49EC.6030806@gmail.com>
References: <CABAQT1ChtWVauLisaRk_KpN3JSWsvUXKKWDTAW6yuW-G32vmMw@mail.gmail.com>
	   <4FC9D021.1030207@ladisch.de>
	 <1338778611.1472.265.camel@rui.sh.intel.com>  <4FCCC92B.3080809@gmail.com>
	 <1338947674.1492.33.camel@rui.sh.intel.com> <4FDB49EC.6030806@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 五, 2012-06-15 at 10:42 -0400, Mark wrote:
> Hi Rui,
> 
> thanks for writing; apologies for the delay I've been coping with some bizarre
> communications from AMD who won't even state thermal specifications for the cpu,
> while 'passing the buck' to Acer who are slippery customers — various methods of
> avoiding giving technical support worthy of the name — too :-)
> 
> On 06/05/2012 09:54 PM, Zhang Rui wrote:
> > you can use module parameter thermal.crt= to override the critical trip
> > point.
> > But I'm not sure if kernel should set a default upper limit or not.
> > Maybe we need another entry for this laptop in thermal_dmi_table.
> thanks, sounds worth a try; at least to prevent a fire :-D
> >
> >> there are 2-3 symbols in the ACPI that may be relevant, FANG, FANW, possibly
> >> FANU; I attach the relevant files
> > FANG/FANW/FANU can be used for fan control?
> > I do not know what these mean as they are not ACPI pre-defined control
> > method.
> > But if all the Aspires machines follow the same rule, then maybe we need
> > a kernel Acer platform driver that handles this.
> I'm simply conjecturing for now, that the letters 'FAN' may be relevant, you're
> the specialist though :-)

No, I only cares about the ACPI pre-defined control methods, which means
their behaviors have been defined in ACPI spec.
Actually, platforms can write whatever AML code, use whatever names, for
their own purpose. so I know nothing more than you on this.

> > thanks,
> > rui
> AMD suggested a channel that would seem designed more for people whose Email
> address is '@acer.com' / '@kernel.org', possibly '@intel.com' than people such as
> me '@gmail.com' :-D
> 
> http://support.amd.com/us/contacts/Pages/EmbeddedTechnicalSupport.aspx
> 
> My question would be, what *is* the thermal range for the Phenom II N970 Mobile
> CPU, reference HMN970DCR42GM ?
> conspicuously absent from http://products.amd.com/en-us/NotebookCPUDetail.aspx?id=733
> 
Sorry, I do not know. I can not help you on this. :(

thanks,
rui

> Aside from the question of whether they've got some technical contact at Acer who
> could verify how — presumably some hardware registers that are somehow accessible
> to the OS — windows seems to manage to keep the CPU relatively cool / fan
> management in the Aspire 5552-7260
> 
> Best regards
> 
> Mark
> 


