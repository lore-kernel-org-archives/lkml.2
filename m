Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab2ASTSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:18:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37717 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932485Ab2ASTSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:18:36 -0500
Message-ID: <4F186C62.6000606@zytor.com>
Date: Thu, 19 Jan 2012 11:17:54 -0800
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
References: <OF70B406E9.8D4A6789-ON85257988.0052C104-85257988.0053DE1E@gdeb.com>	<20120117195841.48fe8236@pyramind.ukuu.org.uk> <OFD4BB6876.6D903346-ON8525798A.00550E62-8525798A.005562A3@gdeb.com> <20120119154504.710e202e@pyramind.ukuu.org.uk> <OF8642E997.5ED041E1-ON8525798A.0056983A-8525798A.0056E05B@LocalDomain> <OF2B909250.6078896E-ON8525798A.0058FF49-8525798A.0061AEA1@gdeb.com> <4F18584F.7060603@zytor.com> <OFE1B368BB.B6249713-ON8525798A.00692513-8525798A.0069B44E@gdeb.com>
In-Reply-To: <OFE1B368BB.B6249713-ON8525798A.00692513-8525798A.0069B44E@gdeb.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 11:14 AM, Michael D Labriola wrote:
>>
>> Yes, and such a patch would be appreciated.
>>
>> The reason it is as it is dates back to before the 32-64 bit 
>> unification, as far as I know.
>>
>> (BIOS reboot is currently not supported on 64 bits, mainly.)
> 
> Well, that does complicate it a bit.  I'll gin something up and see what
> you think.  I guess it will involve having an #ifdef CONFIG_X86_32 block
> inside a single dmi_table structure for the BIOS quirks.
> 
> Actually, set_kbd_reboot is inside the current X86_32 only block, along
> with the one DMI callback that uses it.  Is this correct?
> 

Probably not, although I suspect most of the users of that are 32-bit
only systems.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

