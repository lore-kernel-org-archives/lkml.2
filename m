Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab2GFP5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:57:40 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60309 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab2GFP5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:57:39 -0400
MIME-Version: 1.0
In-Reply-To: <4FF70A49.3040802@gmail.com>
References: <1341588498-21689-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1341588498-21689-6-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAH9JG2XzWS_PF8E4V2bHjq=PtTMEtdDcm1Q03GxK8h4E28Rpjw@mail.gmail.com>
	<4FF70A49.3040802@gmail.com>
Date: Fri, 6 Jul 2012 18:57:37 +0300
Message-ID: <CAHp75Vd2edLv_Tc8w-BXdKe3yjDVdm59-=_aQC8fJk-wmXf_6g@mail.gmail.com>
Subject: Re: [PATCH 6/6] staging: ccg: print MAC addresses via %pM
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Daniel Hazelton <dshadowwolf@gmail.com>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 6:54 PM, Daniel Hazelton <dshadowwolf@gmail.com> wrote:
>>> --- a/drivers/staging/ccg/ccg.c
>>> +++ b/drivers/staging/ccg/ccg.c
>>> @@ -564,9 +564,7 @@ static int rndis_function_bind_config(struct ccg_usb_function *f,
>>>                 return -1;
>>>         }
>>>
>>> -       pr_info("%s MAC: %02X:%02X:%02X:%02X:%02X:%02X\n", __func__,
>>> -               rndis->ethaddr[0], rndis->ethaddr[1], rndis->ethaddr[2],
>>> -               rndis->ethaddr[3], rndis->ethaddr[4], rndis->ethaddr[5]);
>>> +       pr_info("%s MAC: pM\n", __func__, rndis->ethaddr);
> You lost a % there - it should be "%s MAC: %pM\n", no ?
Thanks, I noticed this already. Patch v2 was sent recently.

-- 
With Best Regards,
Andy Shevchenko
