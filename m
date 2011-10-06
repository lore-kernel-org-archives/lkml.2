Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934379Ab1JFFOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 01:14:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57872 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab1JFFOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 01:14:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAKYAXd9wqjK90pn6YHNGKi+gDEqwDV4x14CrY-Nc7JHQ_Ed7xw@mail.gmail.com>
References: <1317825945-1918-1-git-send-email-linkinjeon@gmail.com>
	<1757717892.66886.1317828833207.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
	<CAKYAXd9wqjK90pn6YHNGKi+gDEqwDV4x14CrY-Nc7JHQ_Ed7xw@mail.gmail.com>
Date: Thu, 6 Oct 2011 01:14:07 -0400
Message-ID: <CANz0V+5ybs6K7bGxHnXbyPCnBDZzw-O1X6zBfbmG16XvofJUTA@mail.gmail.com>
Subject: Re: [PATCH v11] mmc : general purpose partition support.
From: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: Andrei Warkentin <awarkentin@vmware.com>, linux-kernel@vger.kernel.org,
        adrian hunter <adrian.hunter@intel.com>,
        linus walleij <linus.walleij@linaro.org>,
        james p freyensee <james_p_freyensee@linux.intel.com>,
        sebras@gmail.com, Ulf Hansson <Ulf.Hansson@stericsson.com>,
        stefan xk nilsson <stefan.xk.nilsson@stericsson.com>,
        per forlin <per.forlin@stericsson.com>,
        johan rudholm <johan.rudholm@stericsson.com>, cjb@laptop.org,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p965EHue031429

HI NamJae,

2011/10/5 NamJae Jeon <linkinjeon@gmail.com>:
>
> How about changing patch like this ?
>
> if (ext_csd[EXT_CSD_BOOT_MULT] && mmc_boot_partition_access(card->host)) {
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â for (idx = 0; idx < MMC_NUM_BOOT_PARTITION; idx++) {
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â part_size = ext_csd[EXT_CSD_BOOT_MULT] << 17;
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â mmc_part_add(card, part_size,
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â EXT_CSD_PART_CONFIG_ACC_BOOT0 + idx,
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â "boot%d", idx, true);
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â }
> Â  Â  Â  Â  Â  Â  Â  Â }
>
> I want to hear the opinion from andrei and
> adrian(mmc_boot_partition_access patch's author)
> Thanks.

I like this.

A
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
