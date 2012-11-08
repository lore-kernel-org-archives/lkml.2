Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab2KHC7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 21:59:37 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:41565 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab2KHC7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 21:59:36 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID qA82woPo005211, This message is released by code: ctaloc0852
Message-ID: <509B1FEA.1040505@realsil.com.cn>
Date: Thu, 8 Nov 2012 10:58:50 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "oakad@yahoo.com" <oakad@yahoo.com>,
        "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v7 0/3] Add modules to support realtek PCIE card reader
References: <cover.1351481260.git.wei_wang@realsil.com.cn> <508F4A88.8010207@realsil.com.cn> <87r4o56w1f.fsf@octavius.laptop.org>
In-Reply-To: <87r4o56w1f.fsf@octavius.laptop.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年11月08日 03:41, Chris Ball 写道:
>
> On Mon, Oct 29 2012, wwang wrote:
>> Hi Chris, Samuel and Alex:
>>
>> Can you help to review this patchset, please?
>>
>> I have asked Greg to remove rts_pstor from the staging tree. So this
>> driver have to be merged into 3.8 kernel, or else Realtek'sPCI-E card
>> reader can not be accessed easily.
> I'm happy with the MMC portion.  I think we're mainly waiting for the
> MFD patch -- Samuel, do you have any remaining review comments that need
> to be fixed?
>
> Thanks,
>
> - Chris.

Hi Chris:

Thank you for your comment.  :-)


Hi Alex:

Do you have any comment on the MEMSTICK part in this v7 patchset? Can 
you help to merge the patch to the kernel tree?

Thanks.
Wei WANG


