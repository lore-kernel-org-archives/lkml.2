Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab2IMGwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:52:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64591 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab2IMGwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:52:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120912202700.GD5997@atomide.com>
References: <1347353664-15906-1-git-send-email-peter.ujfalusi@ti.com>
	<20120912202700.GD5997@atomide.com>
Date: Thu, 13 Sep 2012 08:52:36 +0200
Message-ID: <CACRpkdZjd5FANymXQOuz0nH+d_r6O6GdXrcnZObhq6mZ9cmH7A@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: pinctrl-single: Add pinctrl-single,bits type
 of mux
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 10:27 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Peter Ujfalusi <peter.ujfalusi@ti.com> [120911 01:54]:
>> With pinctrl-single,bits it is possible to update just part of the register
>> within the pinctrl-single,function-mask area.
>> This is useful when one register configures mmore than one pin's mux.
>
>>       size /= sizeof(*mux);   /* Number of elements in array */
>> -     rows = size / 2;        /* Each row is a key value pair */
>> +     rows = size / params;   /* Each row is a key value pair */
>
> Maybe just remove the comment:  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> I don't think it's needed any longer. Other than that,
> thanks for updating the patch:
>
> Acked-by: Tony Lindgren <tony@atomide.com>

Applied minus the comment, plus Tony's ACK, thanks!

Linus Walleij
