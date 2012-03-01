Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2CATzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:55:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab2CATzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:55:19 -0500
Message-ID: <4F4FD412.1040902@redhat.com>
Date: Thu, 01 Mar 2012 16:54:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
References: <4F4E1F91.9080705@redhat.com> <20120229134556.GG21224@aftab> <4F4E3059.7040004@redhat.com> <20120229144054.GH21224@aftab> <3908561D78D1C84285E8C5FCA982C28F040115@ORSMSX104.amr.corp.intel.com> <20120229171626.GJ21224@aftab> <3908561D78D1C84285E8C5FCA982C28F040193@ORSMSX104.amr.corp.intel.com> <20120301112949.GA32410@aftab> <4F4F776B.90609@redhat.com> <3908561D78D1C84285E8C5FCA982C28F040AB7@ORSMSX104.amr.corp.intel.com> <20120301184544.GA3391@aftab> <3908561D78D1C84285E8C5FCA982C28F040B18@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F040B18@ORSMSX104.amr.corp.intel.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 01-03-2012 15:58, Luck, Tony escreveu:
>> Query from where? (And pls don't tell me DMI tables. :-))
> 
> Sorry - but DMI is all we've got.  We need to start using it, and have
> people report bugs when it is wrong. Then it might get better. Linux
> has had some success in shaming BIOS writers with:
> 
>  printk("Your BIOS is buggy ...")
> 
> Our biggest problem here is the life-cycle ... by the time Linux
> users start seeing these problems, the BIOS people have already
> moved on to the next generation system.
> 
> BUT - if Linux wants to play in RAS space - we need this to be
> right - and to do that we need SMBIOS (DMI) bugs to be regarded as
> priority #1.

This approach may work, if we put enough pressure on BIOS bugs. It is
a way better for us than the way EDAC took: adding a sysfs node for some
util to write the labels there. Yet, they did that because a lot of DMI 
tables were wrong.

Well, we can always have a buggy-BIOS quirk file shaming the BIOS writers,
while providing the right values to the end users, as we got bugs reporting
issues with certain motherboards and/or manufacturers.

Regards,
Mauro.
