Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab1JDDtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 23:49:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64021 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1JDDtf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 23:49:35 -0400
MIME-Version: 1.0
In-Reply-To: <m2vcs5lbtx.fsf@bob.laptop.org>
References: <1317641240-15791-1-git-send-email-linkinjeon@gmail.com>
	<m2vcs5lbtx.fsf@bob.laptop.org>
Date: Tue, 4 Oct 2011 12:49:28 +0900
Message-ID: <CAKYAXd_YKrDWC-XOyqYPgtBjbVQz6B+x8J5N1iJv9=4bwRk+tA@mail.gmail.com>
Subject: Re: [PATCH v8] mmc : general purpose partition support.
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

2011/10/4 Chris Ball <cjb@laptop.org>:
> Hi,
>
> On Mon, Oct 03 2011, Namjae Jeon wrote:
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
> v8 doesn't apply against mmc-next, please resend.  mmc-next has moved to:
>   git://dev.laptop.org/users/cjb/mmc mmc-next
>
> (Thanks for reviewing, Andrei -- please send another ACK after v9 is
> submitted, if you don't mind.)
Hi. Chris.
I will resend patch again after rebase from moved mmc-next.
Thanks.
>
> - Chris.
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
>
