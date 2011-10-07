Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab1JGD1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 23:27:24 -0400
Received: from void.printf.net ([89.145.121.20]:40158 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab1JGD1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 23:27:23 -0400
From: Chris Ball <cjb@laptop.org>
To: Andrei Warkentin <awarkentin@vmware.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        adrian hunter <adrian.hunter@intel.com>,
        linus walleij <linus.walleij@linaro.org>,
        james p freyensee <james_p_freyensee@linux.intel.com>,
        sebras@gmail.com, Ulf Hansson <Ulf.Hansson@stericsson.com>,
        stefan xk nilsson <stefan.xk.nilsson@stericsson.com>,
        per forlin <per.forlin@stericsson.com>,
        johan rudholm <johan.rudholm@stericsson.com>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH v12] mmc : general purpose partition support.
References: <1559008816.102998.1317915129522.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Date: Thu, 06 Oct 2011 23:26:58 -0400
In-Reply-To: <1559008816.102998.1317915129522.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
	(Andrei Warkentin's message of "Thu, 6 Oct 2011 08:32:09 -0700 (PDT)")
Message-ID: <m2r52pqy65.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 06 2011, Andrei Warkentin wrote:
>> Subject: [PATCH v12] mmc : general purpose partition support.
>> 
>> It allows gerneral purpose partitions in MMC Device.
>> And I try to simpliy make mmc_blk_alloc_parts using mmc_part
>> structure suggested by Andrei Warkentin.
>> After patching, we can see general purpose partitions like this.
>> > cat /proc/partitions
>>           179 0 847872 mmcblk0
>>           179 192 4096 mmcblk0gp3
>>           179 160 4096 mmcblk0gp2
>>           179 128 4096 mmcblk0gp1
>>           179 96  1052672 mmcblk0gp0
>>           179 64  1024 mmcblk0boot1
>>           179 32  1024 mmcblk0boot0
>> 
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> ---
>
> Acked-by: Andrei Warkentin <andrey.warkentin@gmail.com>

Thanks very much!  Pushed to mmc-next for 3.2 now.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
