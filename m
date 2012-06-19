Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab2FSKc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:32:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60454 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab2FSKc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:32:56 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <22448380.601061340101146820.JavaMail.weblogic@epml24>
References: <22448380.601061340101146820.JavaMail.weblogic@epml24>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 19 Jun 2012 18:32:35 +0800
Message-ID: <CAF+7xW=+yHy3x6mPyG7VqsE3drwweGU_bLZn8VStOmCT2x0gpw@mail.gmail.com>
Subject: Re: [PATCH 1/2] extcon: Set platform drvdata in gpio_extcon_probe()
 and fix irq leak
To: myungjoo.ham@samsung.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Lockwood <lockwood@android.com>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/19 함명주 <myungjoo.ham@samsung.com>:
>> Add missing platform_set_drvdata() in gpio_extcon_probe(), otherwise calling
>> platform_get_drvdata in gpio_extcon_remove() returns NULL.
>>
>> Also add missing free_irq call in gpio_extcon_remove().
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Thanks!
>
>
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>
> I'll apply this patch to the extcon-for-next.
> I would appear in http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next soon after syncing servers.

Hi MyungJoo,
These patches are already in today's linux-next tree.
It's already picked up by Greg.

Regards,
Axel
