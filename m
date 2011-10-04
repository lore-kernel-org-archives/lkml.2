Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab1JDCjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 22:39:51 -0400
Received: from void.printf.net ([89.145.121.20]:52322 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab1JDCju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 22:39:50 -0400
From: Chris Ball <cjb@laptop.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        awarkentin@vmware.com, adrian.hunter@intel.com,
        linus.walleij@linaro.org, james_p_freyensee@linux.intel.com,
        sebras@gmail.com, Ulf.Hansson@stericsson.com,
        stefan.xk.nilsson@stericsson.com, per.forlin@stericsson.com,
        johan.rudholm@stericsson.com
Subject: Re: [PATCH v8] mmc : general purpose partition support.
References: <1317641240-15791-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 03 Oct 2011 22:39:22 -0400
In-Reply-To: <1317641240-15791-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Mon, 3 Oct 2011 20:27:20 +0900")
Message-ID: <m2vcs5lbtx.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 03 2011, Namjae Jeon wrote:
> It allows gerneral purpose partitions in MMC Device.
> And I try to simpliy make mmc_blk_alloc_parts using mmc_part structure suggested by Andrei Warkentin.
> After patching, we can see general purpose partitions like this.
>> cat /proc/partitions
>           179 0 847872 mmcblk0
>           179 192 4096 mmcblk0gp3
>           179 160 4096 mmcblk0gp2
>           179 128 4096 mmcblk0gp1
>           179 96  1052672 mmcblk0gp0
>           179 64  1024 mmcblk0boot1
>           179 32  1024 mmcblk0boot0
>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>

v8 doesn't apply against mmc-next, please resend.  mmc-next has moved to:
   git://dev.laptop.org/users/cjb/mmc mmc-next

(Thanks for reviewing, Andrei -- please send another ACK after v9 is
submitted, if you don't mind.)

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
