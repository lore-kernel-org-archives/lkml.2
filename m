Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933791Ab0GOQiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 12:38:09 -0400
Received: from mail.candelatech.com ([208.74.158.172]:41566 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933695Ab0GOQiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 12:38:07 -0400
Message-ID: <4C3F396B.7080106@candelatech.com>
Date: Thu, 15 Jul 2010 09:38:03 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression:  2.6.34 boot fails on E5405 system, bisected:  de08e2c26
References: <4C3D067C.10507@candelatech.com>	<4C3D101E.5010605@candelatech.com>	<20100713191958.260478c0@virtuousgeek.org>	<4C3E077C.9040609@zytor.com> <20100714115904.7004be74@virtuousgeek.org> <43F901BD926A4E43B106BF17856F0755EA8EEA9B@orsmsx508.amr.corp.intel.com> <4C3E162C.4040900@zytor.com>
In-Reply-To: <4C3E162C.4040900@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 12:55 PM, H. Peter Anvin wrote:
> On 07/14/2010 12:01 PM, Pan, Jacob jun wrote:
>>
>> Can we use PCI_EXT_CAP_NEXT to replace this line?
>> pos = (pcie_cap>>  20)&  0xffc
>>
>
> Presumably, I haven't checked the definition of that macro, but that
> would be the logical semantics.
>
> 	-hpa

Are one of you guys going to submit a fix upstream (and hopefully
to stable)?  Since you guys actually understand the code, probably
best that you do it....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

