Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab1DKJIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 05:08:25 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54624 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab1DKJIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 05:08:23 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikVeXvfSBS-xLDXVdesKJpKdtUVqg@mail.gmail.com>
References: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
	<BANLkTikZVDejarZ4O5KgNS7S4fxBLSmANA@mail.gmail.com>
	<BANLkTikVeXvfSBS-xLDXVdesKJpKdtUVqg@mail.gmail.com>
Date: Mon, 11 Apr 2011 11:08:22 +0200
Message-ID: <BANLkTikaerLi9NC153L=kJM2hAC_VerBKQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] mmc: use nonblock mmc requests to minimize latency
From: Per Forlin <per.forlin@linaro.org>
To: Jae hoon Chung <jh80.chung@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2011 13:55, Jae hoon Chung <jh80.chung@gmail.com> wrote:
> Hi Per..
>
> I'm applied your patch..and sent the patch about dw_mmc.c.
> I think good this approach..
>
Do you have any test results from the mmc_tests I added?
I am interested in the results.

Regards,
Per

> Tested-by: Jaehoon Chung <jh80.chung@samsung.com>
>
> Regards,
> Jaehoon Chung
>
> 2011/4/9 Linus Walleij <linus.walleij@linaro.org>:
>> On Wed, Apr 6, 2011 at 9:07 PM, Per Forlin <per.forlin@linaro.org> wrote:
>>
>>> The intention for introducing none blocking mmc requests is to minimize the
>>> time between a mmc request ends and another mmc request starts.
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org> FWIW, I've looked at the
>> patches so many times I'm already blind for any remaining bugs...
>>
>> Yours,
>> Linus Walleij
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
