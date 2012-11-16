Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab2KPRof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:44:35 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60879 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab2KPRoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:44:32 -0500
Message-ID: <50A67B7C.4090608@pobox.com>
Date: Fri, 16 Nov 2012 12:44:28 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Huang, Shane" <Shane.Huang@amd.com>
CC: Aaron Lu <aaron.lu@intel.com>, Robert Hancock <hancockrwd@gmail.com>,
        Borislav Petkov <bp@amd64.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ata4.00: failed to get Identify Device Data, Emask 0x1
References: <20121016144932.GA24044@aftab.osrc.amd.com> <20121016155824.00d5b618@pyramind.ukuu.org.uk> <20121016151830.GB24044@aftab.osrc.amd.com> <507E0C1A.1010705@intel.com> <507E392E.2010305@gmail.com> <507E5671.6070504@intel.com> <43EB3AB3EEFE8D43B525F4D2EAF507E107EA8AA9@SCYBEXDAG03.amd.com> <43EB3AB3EEFE8D43B525F4D2EAF507E107EF3D53@SCYBEXDAG04.amd.com>
In-Reply-To: <43EB3AB3EEFE8D43B525F4D2EAF507E107EF3D53@SCYBEXDAG04.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 11:02 AM, Huang, Shane wrote:
>> I tried word 78 bit 5(Hardware Feature Control) which does not work,
>> it is 0 on my HDD sample with log 30h page 08h and DevSlp supported.
>>
>> Seems that word 78 bit 5 is only the sufficient condition, not the
>> essential condition. Do you guys have suggestion?
>
> Eventually I received the confirmation from the DevSlp HDD vendor,
> bit 5 should be and will be set in production drives with log 30h
> page 08h supported. So I will submit a patch to use it instead.
>
>
> Hi Jeff,
>
> I don't know when I will receive some production drives to verify
> my patch, are you okay if I submit my patch first without testing
> so as to meet kernel 3.7 bug fix window?

Yes, please do.

	Jeff




