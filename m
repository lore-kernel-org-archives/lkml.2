Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab2ASRxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:53:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37410 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932485Ab2ASRxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:53:10 -0500
Message-ID: <4F18584F.7060603@zytor.com>
Date: Thu, 19 Jan 2012 09:52:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Michael D Labriola <mlabriol@gdeb.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Kushal Koolwal <kushalkoolwal@gmail.com>, linux-kernel@vger.kernel.org,
        michael.d.labriola@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Matthew Garrett <mjg59@srcf.ucam.org>, support@versalogic.com,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: Re: [PATCH] x86, reboot: skip DMI checks if reboot set by user
References: <OF70B406E9.8D4A6789-ON85257988.0052C104-85257988.0053DE1E@gdeb.com>	<20120117195841.48fe8236@pyramind.ukuu.org.uk> <OFD4BB6876.6D903346-ON8525798A.00550E62-8525798A.005562A3@gdeb.com> <20120119154504.710e202e@pyramind.ukuu.org.uk> <OF8642E997.5ED041E1-ON8525798A.0056983A-8525798A.0056E05B@LocalDomain> <OF2B909250.6078896E-ON8525798A.0058FF49-8525798A.0061AEA1@gdeb.com>
In-Reply-To: <OF2B909250.6078896E-ON8525798A.0058FF49-8525798A.0061AEA1@gdeb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 09:46 AM, Michael D Labriola wrote:
>
> Random question...  why do we have a reboot_init function that does DMI
> checking with reboot_dmi_table (callbacks are mostly set_bios_reboot, but
> there is a single set_kbd_reboot) and also a pci_reboot_init which does
> the DMI check again using a separate pci_reboot_dmi_table (all callbacks
> are to set_pci_reboot)?
>
> Wouldn't it make more sense to do a single DMI scan using one big table?
>

Yes, and such a patch would be appreciated.

The reason it is as it is dates back to before the 32-64 bit 
unification, as far as I know.

(BIOS reboot is currently not supported on 64 bits, mainly.)

	-hpa

