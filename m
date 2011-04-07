Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1DGQhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:37:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34970 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab1DGQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pNBvCVzudXe4XD7V58OqL6OANv6kMfbWrbYDaokG1VMdpjB9CL18fSglEV/3JY9r4E
         3Ojd3P690gAzw26O+sllG/BCm95m5eQZc7jK8C7VNF9Qlc05EUXgQt3rlTy7Y8GW2Ypm
         /CZENVm7gv7FR1vGeYQ5Bt3t2vCKG0x9q11TU=
Message-ID: <4D9DE834.5070500@gmail.com>
Date: Thu, 07 Apr 2011 09:37:08 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]drivers:staging:hv:hv_mouse.c Fix build error in hv_mouse.
References: <1302186996-23392-1-git-send-email-justinmattock@gmail.com> <20110407162243.GA31002@suse.de>
In-Reply-To: <20110407162243.GA31002@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2011 09:22 AM, Greg KH wrote:
> On Thu, Apr 07, 2011 at 07:36:36AM -0700, Justin P. Mattock wrote:
>> The patch below fixes a build error..
>>
>>    LD [M]  drivers/staging/hv/hv_utils.o
>>    CC [M]  drivers/staging/hv/hv_mouse.o
>> drivers/staging/hv/hv_mouse.c: In function ‘ReleaseInputDevice’:
>> drivers/staging/hv/hv_mouse.c:293:3: error: implicit declaration of function ‘udelay’ [-Werror=implicit-function-declaration]
>> drivers/staging/hv/hv_mouse.c: In function ‘MousevscOnReceiveInputReport’:
>> drivers/staging/hv/hv_mouse.c:418:27: warning: variable ‘inputDriver’ set but not used [-Wunused-but-set-variable]
>> drivers/staging/hv/hv_mouse.c: In function ‘MousevscOnDeviceAdd’:
>> drivers/staging/hv/hv_mouse.c:663:27: warning: variable ‘inputDriver’ set but not used [-Wunused-but-set-variable]
>> cc1: some warnings being treated as errors
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/staging/hv/hv_mouse.c |    1 +
>>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> Thanks, but this is already in the linux-next tree and will go to Linus
> in a few hours.
>
> greg k-h
>


alright... no worries!!

Justin P. Mattock
