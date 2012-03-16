Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423087Ab2CPPwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:52:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39492 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965504Ab2CPPwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:52:09 -0400
MIME-Version: 1.0
In-Reply-To: <s5hehsstx90.wl%tiwai@suse.de>
References: <1331908876-1268-1-git-send-email-lucas.demarchi@profusion.mobi> <s5hehsstx90.wl%tiwai@suse.de>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Fri, 16 Mar 2012 12:51:46 -0300
Message-ID: <CAMOw1v5j7WMOLOs8Dzwi0kjYz7zQ1_3ouzqzfoc114x4MQM0UQ@mail.gmail.com>
Subject: Re: [PATCH] Remove references to /etc/modprobe.conf
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kay.sievers@vrfy.org, rdunlap@xenotime.net, mchehab@infradead.org,
        perex@perex.cz, hjlipp@web.de, davem@davemloft.net,
        w.sang@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takahashi,

On Fri, Mar 16, 2012 at 11:51 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Fri, 16 Mar 2012 11:41:16 -0300,
> Lucas De Marchi wrote:
>>
>> Usage of /etc/modprobe.conf file was deprecated by module-init-tools and
>> is no longer parsed by new kmod tool. References to this file are
>> replaced in Documentation, comments and Kconfig according to the
>> context.
>>
>> There are also some references to the old /etc/modules.conf from 2.4
>> kernels that are being removed.
>>
>> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
>
> It's nice to correct the document, but the change like
>
> -  /etc/modprobe.conf to ensure that the aoe module is loaded when
> +  /etc/modprobe.d/aoe.conf to ensure that the aoe module is loaded when
>
> might be misleading since it looks as if the fixed config file name
> must be used.

What text do you prefer here? I used a mix of them throughout the
patch. Generally when text said it was giving an example I used a
fixed filename. Otherwise I used "/etc/modprobe.d/*.conf" or "a
configuration file in /etc/modprobe.d/"


> Also, the config file name should be with a number prefix.  At least,
> it's recommended so in the recent distros to determine the loading
> order.  However, which number to be used depends on pretty much on the
> distribution.
>
> So, from both points, it'd be better to mention that it's an example
> file name.

Could you rephrase my change so I include it in a v2 patch?

Lucas De Marchi
