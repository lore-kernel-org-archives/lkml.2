Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab2IMHfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:35:46 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:59665 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754592Ab2IMHfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:35:44 -0400
Message-ID: <50518CF8.2050106@ti.com>
Date: Thu, 13 Sep 2012 10:36:24 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: pinctrl-single: Add pinctrl-single,bits type
 of mux
References: <1347353664-15906-1-git-send-email-peter.ujfalusi@ti.com> <20120912202700.GD5997@atomide.com> <CACRpkdZjd5FANymXQOuz0nH+d_r6O6GdXrcnZObhq6mZ9cmH7A@mail.gmail.com>
In-Reply-To: <CACRpkdZjd5FANymXQOuz0nH+d_r6O6GdXrcnZObhq6mZ9cmH7A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 09:52 AM, Linus Walleij wrote:
> On Wed, Sep 12, 2012 at 10:27 PM, Tony Lindgren <tony@atomide.com> wrote:
>> * Peter Ujfalusi <peter.ujfalusi@ti.com> [120911 01:54]:
>>> With pinctrl-single,bits it is possible to update just part of the register
>>> within the pinctrl-single,function-mask area.
>>> This is useful when one register configures mmore than one pin's mux.
>>
>>>       size /= sizeof(*mux);   /* Number of elements in array */
>>> -     rows = size / 2;        /* Each row is a key value pair */
>>> +     rows = size / params;   /* Each row is a key value pair */
>>
>> Maybe just remove the comment:  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>> I don't think it's needed any longer. Other than that,
>> thanks for updating the patch:
>>
>> Acked-by: Tony Lindgren <tony@atomide.com>
> 
> Applied minus the comment, plus Tony's ACK, thanks!

Thank you Linus, I was about to send the v3 with the removed comment.

-- 
Péter
