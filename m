Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab2KIPIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:08:15 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:40636 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2KIPIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:08:13 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID qA9F7IH2007622, This message is released by code: ctaloc0852
Message-ID: <509D1C25.9040909@realsil.com.cn>
Date: Fri, 9 Nov 2012 23:07:17 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
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

于 11/08/2012 03:41 AM, Chris Ball 写道:
> Hi,
>
> On Mon, Oct 29 2012, wwang wrote:
> I'm happy with the MMC portion.  I think we're mainly waiting for the
> MFD patch -- Samuel, do you have any remaining review comments that need
> to be fixed?
>
> Thanks,
>
> - Chris.

Hi Chris:

I have noticed that the file rtsx_pci_sdmmc.c in your mmc-next branch is 
still v6 patch.  In v7 patch, this MMC part has also been modified to 
comply with my MFD portion.  So please update to this version.

And one more question. Samuel have merged all of my patch set in his 
for-next branch, including the MMC part.  I don't know whether this will 
conflict with your tree in the next merge.

Hi Samuel:

Since the whole patch set has been merged in your for-next branch, does 
it mean that you will help to merge all of the three parts to linus's tree?

Thank you!
Wei WANG





