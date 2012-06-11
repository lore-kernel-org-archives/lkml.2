Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab2FKQB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:01:59 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61086 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab2FKQB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:01:58 -0400
Message-ID: <4FD61672.8070607@linaro.org>
Date: Mon, 11 Jun 2012 17:01:54 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: Re: [PATCH 01/14] rtc: ab8500-rtc: IRQF_ONESHOT when requesting a
 threaded IRQ
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-2-git-send-email-lee.jones@linaro.org> <201206111531.20468.arnd@arndb.de> <4FD610AE.7010001@linaro.org> <20120611155128.GA18005@kroah.com>
In-Reply-To: <20120611155128.GA18005@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/12 16:51, Greg Kroah-Hartman wrote:
> On Mon, Jun 11, 2012 at 04:37:18PM +0100, Lee Jones wrote:
>> On 11/06/12 16:31, Arnd Bergmann wrote:
>>> On Monday 11 June 2012, Lee Jones wrote:
>>>> The kernel now forces IRQs to be ONESHOT if no IRQ handler is passed.
>>>>
>>>> Cc: Alessandro Zummo<a.zummo@towertech.it>
>>>> Cc: rtc-linux@googlegroups.com
>>>> Signed-off-by: Lee Jones<lee.jones@linaro.org>
>>>
>>> Isn't this a bug fix that should be applied to the stable kernels too?
>>
>> Possibly. Should we alert Greg (CC'ed - alerted)?
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
> 
> </formletter>

I wasn't submitting, merely asking if it would be suitable for inclusion. :)

If it is, I'd be happy to _properly_ submit this and its ab8500-gpadc counterpart.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515 
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
