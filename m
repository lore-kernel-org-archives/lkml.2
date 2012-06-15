Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab2FOOnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 10:43:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37040 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2FOOnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 10:43:07 -0400
Message-ID: <4FDB49EC.6030806@gmail.com>
Date: Fri, 15 Jun 2012 10:42:52 -0400
From: Mark <markieb.lists.20090330@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>, Clemens Ladisch <clemens@ladisch.de>,
        linux-kernel@vger.kernel.org
Subject: Re: thermal_zone trip_point_0_temp =?UTF-8?B?MjAwwrBD?=
References: <CABAQT1ChtWVauLisaRk_KpN3JSWsvUXKKWDTAW6yuW-G32vmMw@mail.gmail.com>   <4FC9D021.1030207@ladisch.de> <1338778611.1472.265.camel@rui.sh.intel.com>  <4FCCC92B.3080809@gmail.com> <1338947674.1492.33.camel@rui.sh.intel.com>
In-Reply-To: <1338947674.1492.33.camel@rui.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui,

thanks for writing; apologies for the delay I've been coping with some bizarre
communications from AMD who won't even state thermal specifications for the cpu,
while 'passing the buck' to Acer who are slippery customers — various methods of
avoiding giving technical support worthy of the name — too :-)

On 06/05/2012 09:54 PM, Zhang Rui wrote:
> you can use module parameter thermal.crt= to override the critical trip
> point.
> But I'm not sure if kernel should set a default upper limit or not.
> Maybe we need another entry for this laptop in thermal_dmi_table.
thanks, sounds worth a try; at least to prevent a fire :-D
>
>> there are 2-3 symbols in the ACPI that may be relevant, FANG, FANW, possibly
>> FANU; I attach the relevant files
> FANG/FANW/FANU can be used for fan control?
> I do not know what these mean as they are not ACPI pre-defined control
> method.
> But if all the Aspires machines follow the same rule, then maybe we need
> a kernel Acer platform driver that handles this.
I'm simply conjecturing for now, that the letters 'FAN' may be relevant, you're
the specialist though :-)
> thanks,
> rui
AMD suggested a channel that would seem designed more for people whose Email
address is '@acer.com' / '@kernel.org', possibly '@intel.com' than people such as
me '@gmail.com' :-D

http://support.amd.com/us/contacts/Pages/EmbeddedTechnicalSupport.aspx

My question would be, what *is* the thermal range for the Phenom II N970 Mobile
CPU, reference HMN970DCR42GM ?
conspicuously absent from http://products.amd.com/en-us/NotebookCPUDetail.aspx?id=733

Aside from the question of whether they've got some technical contact at Acer who
could verify how — presumably some hardware registers that are somehow accessible
to the OS — windows seems to manage to keep the CPU relatively cool / fan
management in the Aspire 5552-7260

Best regards

Mark

