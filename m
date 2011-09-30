Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab1I3Ita (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 04:49:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:44698 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247Ab1I3It1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 04:49:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,466,1312182000"; 
   d="scan'208";a="72621533"
Message-ID: <4E858292.40905@intel.com>
Date: Fri, 30 Sep 2011 11:49:22 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: NamJae Jeon <linkinjeon@gmail.com>
CC: Andrei Warkentin <awarkentin@vmware.com>, linux-kernel@vger.kernel.org,
        linus walleij <linus.walleij@linaro.org>,
        james p freyensee <james_p_freyensee@linux.intel.com>,
        sebras@gmail.com, Ulf Hansson <Ulf.Hansson@stericsson.com>,
        stefan xk nilsson <stefan.xk.nilsson@stericsson.com>,
        per forlin <per.forlin@stericsson.com>,
        johan rudholm <johan.rudholm@stericsson.com>, cjb@laptop.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH v3] mmc : general purpose partition support.
References: <1317309431-1898-1-git-send-email-linkinjeon@gmail.com> <1522108758.811204.1317316828352.JavaMail.root@zimbra-prod-mbox-2.vmware.com> <CAKYAXd_1jY23C8NTvP7NizZEseb7G2bbtJYq7RvF1vaJaZgh_Q@mail.gmail.com> <4E855832.4030603@intel.com> <CAKYAXd-rHyL3uwF0B3UpY=ejxkB=+iNYfHQR7kt2ARcHV1NPkg@mail.gmail.com> <CAKYAXd9HzXOpKON+k=Prr-9wMq1Cr6+mZaDbvhTGe=r-1xpGSA@mail.gmail.com>
In-Reply-To: <CAKYAXd9HzXOpKON+k=Prr-9wMq1Cr6+mZaDbvhTGe=r-1xpGSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/11 11:11, NamJae Jeon wrote:
> 2011/9/30 NamJae Jeon<linkinjeon@gmail.com>:
>> 2011/9/30 Adrian Hunter<adrian.hunter@intel.com>:
>>> Perhaps rebase against Chris' mmc-next branch
>> I made this patch after rebasing Chris'mmc-next yesterday.
> Hi. Adrian.
> There is the overlapped code between your patch and my patch.
> What should we do ?

Rebase and ensure that boot partitions are only added if
mmc_boot_partition_access(card->host) is true

>>>
>>>
>>>
>>
>

