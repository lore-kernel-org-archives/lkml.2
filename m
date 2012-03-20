Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662Ab2CTPp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:45:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61212 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760259Ab2CTPpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:45:54 -0400
Message-ID: <4F68A60D.2020303@gmail.com>
Date: Tue, 20 Mar 2012 16:45:17 +0100
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Shea Levy <shea@shealevy.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: EFI Boot Stub Early Console
References: <4F5E46EA.7020602@shealevy.com> <4F5E47E4.2070303@shealevy.com>  <4F5E74A0.60001@zytor.com> <4F5E761B.7010608@shealevy.com>  <4F5E775D.7080702@zytor.com> <4F648DD3.3000405@shealevy.com>  <1332069701.4041.42.camel@mfleming-mobl1.ger.corp.intel.com>  <4F65D09B.4050807@shealevy.com>  <1332146834.4041.46.camel@mfleming-mobl1.ger.corp.intel.com>  <20120319155639.7cff5df6@pyx> <1332172989.4041.52.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1332172989.4041.52.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Matt,

Op 19-03-12 17:03, Matt Fleming schreef:
> On Mon, 2012-03-19 at 15:56 +0000, Alan Cox wrote:
>>>> any bootloader (including the bootstub) will call ExitBootServices() 
>>>> before any printk'ing actually happens?? Or am I misunderstanding the 
>>>> spec somehow? I suppose I could just try it and see what happens...
>>> Oops. Good point, that isn't going to work.
>> Surely it works fine if you are using bootstub directly from EFI ?
> Yeah, up until the point you call ExitBootServices(), which is very
> early in the boot process. After that you can't rely on the validity of
> the console pointers in the system table.
>
I think my system spontaneously rebooted when I tried to
do some output right after ExitBootServices when debugging
the efi stub, so not only is this unreliable, it will fail to boot for
at least some systems out there.

~Maarten
