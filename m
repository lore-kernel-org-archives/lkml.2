Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab1GEVbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 17:31:55 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34392 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab1GEVby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 17:31:54 -0400
MIME-Version: 1.0
In-Reply-To: <20110705132706.f610abb0.rdunlap@xenotime.net>
References: <1309895008-2587-1-git-send-email-per.forlin@linaro.org>
	<1309895008-2587-2-git-send-email-per.forlin@linaro.org>
	<20110705132706.f610abb0.rdunlap@xenotime.net>
Date: Tue, 5 Jul 2011 23:31:53 +0200
Message-ID: <CAJ0pr18MS-zA8xcjE90YQPaG1aUGJZAh_ZFAzhpguPSF-f5sKw@mail.gmail.com>
Subject: Re: [PATCH v3] mmc: documentation of mmc non-blocking request usage
 and design.
From: Per Forlin <per.forlin@linaro.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-doc@vger.kernel.org,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sourav Poddar <sourav.poddar@ti.com>,
        Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 July 2011 22:27, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Tue,  5 Jul 2011 21:43:28 +0200 Per Forlin wrote:
>
>> Documentation about the background and the design of mmc non-blocking.
>> Host driver guidelines to minimize request preparation overhead.
>>
>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>> ---
>
> It would be better to omit the introductory email and put all of its comments
> in this one [PATCH] email.
>
I agree. I'll put the changelog after "--" to exclude it from the
commit message.
All of your comments will be updated in v4.

Thanks for your comments,
Per
