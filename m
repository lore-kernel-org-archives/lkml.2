Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab1JDUUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:20:20 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:13619 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933567Ab1JDUUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:20:18 -0400
Date: Tue, 4 Oct 2011 13:20:16 -0700 (PDT)
From: Andrei Warkentin <awarkentin@vmware.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org, adrian hunter <adrian.hunter@intel.com>,
        linus walleij <linus.walleij@linaro.org>,
        james p freyensee <james_p_freyensee@linux.intel.com>,
        sebras@gmail.com, Ulf Hansson <Ulf.Hansson@stericsson.com>,
        stefan xk nilsson <stefan.xk.nilsson@stericsson.com>,
        per forlin <per.forlin@stericsson.com>,
        johan rudholm <johan.rudholm@stericsson.com>, cjb@laptop.org,
        linux-mmc@vger.kernel.org
Message-ID: <1093389.39472.1317759616924.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <1317750317-4489-1-git-send-email-linkinjeon@gmail.com>
Subject: Re: [PATCH v10] mmc : general purpose partition support.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.61.163]
X-Mailer: Zimbra 7.1.1_GA_3225 (ZimbraWebClient - FF3.0 (Linux)/7.1.1_GA_3225)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

----- Original Message -----
> From: "Namjae Jeon" <linkinjeon@gmail.com>
> To: cjb@laptop.org, linux-mmc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org, awarkentin@vmware.com, "adrian hunter" <adrian.hunter@intel.com>, "linus walleij"
> <linus.walleij@linaro.org>, "james p freyensee" <james_p_freyensee@linux.intel.com>, sebras@gmail.com, "Ulf Hansson"
> <Ulf.Hansson@stericsson.com>, "stefan xk nilsson" <stefan.xk.nilsson@stericsson.com>, "per forlin"
> <per.forlin@stericsson.com>, "johan rudholm" <johan.rudholm@stericsson.com>, "Namjae Jeon" <linkinjeon@gmail.com>
> Sent: Tuesday, October 4, 2011 1:45:17 PM
> Subject: [PATCH v10] mmc : general purpose partition support.
> 
> It allows gerneral purpose partitions in MMC Device.
> And I try to simpliy make mmc_blk_alloc_parts using mmc_part
> structure suggested by Andrei Warkentin.
> After patching, we can see general purpose partitions like this.
> > cat /proc/partitions
>           179 0 847872 mmcblk0
>           179 192 4096 mmcblk0gp3
>           179 160 4096 mmcblk0gp2
>           179 128 4096 mmcblk0gp1
>           179 96  1052672 mmcblk0gp0
>           179 64  1024 mmcblk0boot1
>           179 32  1024 mmcblk0boot0
> 
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> ---

Acked-by: Andrei Warkentin <andrey.warkentin@gmail.com>

A
