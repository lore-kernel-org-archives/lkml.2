Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1LXB3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 20:29:48 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50678 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab1LXB3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 20:29:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6569"; a="147350507"
X-IronPort-AV: E=Sophos;i="4.71,399,1320652800"; 
   d="scan'208";a="151787180"
Message-ID: <4EF52AFF.5040902@qca.qualcomm.com>
Date: Sat, 24 Dec 2011 03:29:35 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "John W. Linville" <linville@tuxdriver.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: build failure after merge of the final tree (wireless
 tree related)
References: <20111222165849.df5ea3e2997375de24f1490b@canb.auug.org.au> <4EF3616D.5050506@suse.cz> <4EF4E9A8.7070102@suse.cz>
In-Reply-To: <4EF4E9A8.7070102@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.10.226]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2011 10:50 PM, Michal Marek wrote:
>> But I wonder why you need to link all the object files twice? Usually,
>> > drivers have a foo_common.ko and foo_{usb,pci,whatever}.ko that provide
>> > the pci/usb/whatever driver.
>
> Another option is to build both drivers in a single module. Or, as a
> band-aid, make the two drivers module-only, by adding 'depends on m' to
> their Kconfig entries.

I'll send the band-aid to John first and remove it once I have created
the ath6kl core module.

Thanks for the help.

Kalle
