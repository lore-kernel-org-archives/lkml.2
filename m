Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030444Ab2CTQnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:43:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47874 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab2CTQnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:43:45 -0400
Message-ID: <4F68B3A6.4080404@zytor.com>
Date: Tue, 20 Mar 2012 09:43:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
CC: Matt Fleming <matt.fleming@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Shea Levy <shea@shealevy.com>, linux-kernel@vger.kernel.org
Subject: Re: EFI Boot Stub Early Console
References: <4F5E46EA.7020602@shealevy.com> <4F5E47E4.2070303@shealevy.com>  <4F5E74A0.60001@zytor.com> <4F5E761B.7010608@shealevy.com>  <4F5E775D.7080702@zytor.com> <4F648DD3.3000405@shealevy.com>  <1332069701.4041.42.camel@mfleming-mobl1.ger.corp.intel.com>  <4F65D09B.4050807@shealevy.com>  <1332146834.4041.46.camel@mfleming-mobl1.ger.corp.intel.com>  <20120319155639.7cff5df6@pyx> <1332172989.4041.52.camel@mfleming-mobl1.ger.corp.intel.com> <4F68A60D.2020303@gmail.com>
In-Reply-To: <4F68A60D.2020303@gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 08:45 AM, Maarten Lankhorst wrote:
> Hey Matt,
> 
> Op 19-03-12 17:03, Matt Fleming schreef:
>> On Mon, 2012-03-19 at 15:56 +0000, Alan Cox wrote:
>>>>> any bootloader (including the bootstub) will call ExitBootServices() 
>>>>> before any printk'ing actually happens?? Or am I misunderstanding the 
>>>>> spec somehow? I suppose I could just try it and see what happens...
>>>> Oops. Good point, that isn't going to work.
>>> Surely it works fine if you are using bootstub directly from EFI ?
>> Yeah, up until the point you call ExitBootServices(), which is very
>> early in the boot process. After that you can't rely on the validity of
>> the console pointers in the system table.
>>
> I think my system spontaneously rebooted when I tried to
> do some output right after ExitBootServices when debugging
> the efi stub, so not only is this unreliable, it will fail to boot for
> at least some systems out there.
> 

I would expect it to fail for just about any system.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

