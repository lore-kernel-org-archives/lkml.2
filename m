Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab2G3OQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:16:58 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:36968 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753725Ab2G3OQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:16:57 -0400
Message-ID: <50169786.9000109@ti.com>
Date: Mon, 30 Jul 2012 17:17:42 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120723 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: twl6040: Fix GPO mask
References: <1342603220-13287-1-git-send-email-peter.ujfalusi@ti.com> <1342603220-13287-2-git-send-email-peter.ujfalusi@ti.com> <CACRpkdaOmCe05NF2d5-1xqx7UmY80LTZXJG_Lj6rnFqyk_OvHg@mail.gmail.com>
In-Reply-To: <CACRpkdaOmCe05NF2d5-1xqx7UmY80LTZXJG_Lj6rnFqyk_OvHg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On 07/28/2012 01:45 AM, Linus Walleij wrote:
> On Wed, Jul 18, 2012 at 11:20 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> 
>>  #define TWL6040_GPO1                   0x01
>>  #define TWL6040_GPO2                   0x02
>> -#define TWL6040_GPO3                   0x03
>> +#define TWL6040_GPO3                   0x04
> 
> Maybe a stupid question but does these register defines really belong in that
> header file? Can't you do a separate patch moving them into the driver per
> se?

I thought about that but in this way the header file can be used as
documentation for the register bits of twl6040.
The GPIO driver do not use these defines, it is using shift to address the
correct bits in the GPO register.

Regards,
Péter
