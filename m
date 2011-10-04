Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab1JDQg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:36:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38989 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab1JDQg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:36:28 -0400
MIME-Version: 1.0
In-Reply-To: <m2botwloeq.fsf@bob.laptop.org>
References: <1317745057-6328-1-git-send-email-linkinjeon@gmail.com>
	<m2botwloeq.fsf@bob.laptop.org>
Date: Wed, 5 Oct 2011 01:36:26 +0900
Message-ID: <CAKYAXd_OhouoyExiWJCzkDSTUUB4cXafLjRPbHwMYgQ6dhsr9A@mail.gmail.com>
Subject: Re: [PATCH v9] mmc : general purpose partition support.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        awarkentin@vmware.com, adrian.hunter@intel.com,
        linus.walleij@linaro.org, james_p_freyensee@linux.intel.com,
        sebras@gmail.com, Ulf.Hansson@stericsson.com,
        stefan.xk.nilsson@stericsson.com, per.forlin@stericsson.com,
        johan.rudholm@stericsson.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/5 Chris Ball <cjb@laptop.org>:
> Hi,
>
> On Tue, Oct 04 2011, Namjae Jeon wrote:
>> It allows gerneral purpose partitions in MMC Device.
>> And I try to simpliy make mmc_blk_alloc_parts using mmc_part structure suggested by Andrei Warkentin.
>> After patching, we can see general purpose partitions like this.
>>> cat /proc/partitions
>>           179 0 847872 mmcblk0
>>           179 192 4096 mmcblk0gp3
>>           179 160 4096 mmcblk0gp2
>>           179 128 4096 mmcblk0gp1
>>           179 96  1052672 mmcblk0gp0
>>           179 64  1024 mmcblk0boot1
>>           179 32  1024 mmcblk0boot0
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>
> Still doesn't apply here.  Are you sure you're on the "mmc-next" branch
> of the repository?
Hi. Chris.

I receive mmc-next you inform like this.

git clone git://dev.laptop.org/users/cjb/mmc

What I did wrong ?

Thanks.
>
> Thanks,
>
> - Chris.
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
>
