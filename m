Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab2IDXvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:51:22 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:39647 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757125Ab2IDXvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:51:20 -0400
Message-ID: <504693E4.8050808@xenotime.net>
Date: Tue, 04 Sep 2012 16:51:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH -next] extcon: extcon-arizona depends on INPUT
References: <20120824172820.ee0f412d2944b08789414207@canb.auug.org.au> <5037B41C.6040703@xenotime.net> <503AB70E.2000407@samsung.com>
In-Reply-To: <503AB70E.2000407@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2012 04:53 PM, Chanwoo Choi wrote:

> On 08/25/2012 02:04 AM, Randy Dunlap wrote:
> 
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> extcon-arizona uses input_*() functions so it should depend
>> on INPUT.
>>
>> ERROR: "input_event" [drivers/extcon/extcon-arizona.ko] undefined!
>> ERROR: "input_free_device" [drivers/extcon/extcon-arizona.ko] undefined!
>> ERROR: "input_register_device" [drivers/extcon/extcon-arizona.ko] undefined!
>> ERROR: "input_set_capability" [drivers/extcon/extcon-arizona.ko] undefined!
>> ERROR: "input_allocate_device" [drivers/extcon/extcon-arizona.ko] undefined!
>> ERROR: "input_unregister_device" [drivers/extcon/extcon-arizona.ko] undefined!
>>
>> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> ---
> 
> Thanks much,
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> 
> I will apply this patch to
> http://10.90.51.51/cgi-bin/gitweb.cgi?p=linux-samsung;a=shortlog;h=refs/heads/extcon-for-next
> and you can check it after some hours.

Hi,
This build error still happens in linux-next of 20120904.

Can we get the patch merged for linux-next?

thanks,
-- 
~Randy
