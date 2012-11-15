Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab2KODnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 22:43:40 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4223 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933178Ab2KODni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 22:43:38 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <50A464E4.1080105@broadcom.com>
Date: Wed, 14 Nov 2012 19:43:32 -0800
From: "Nithin Nayak Sujir" <nsujir@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028
 Thunderbird/16.0.2
MIME-Version: 1.0
To: "David Rientjes" <rientjes@google.com>
cc: "Paul Gortmaker" <paul.gortmaker@windriver.com>,
        "Denys Fedoryshchenko" <denys@visp.net.lb>,
        "Michael Chan" <mchan@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Latest 3.6.6 are not compiling due tg3 network driver,
 hwmon_device_unregister
References: <8b566c4a9ee622737212dc17291ee238@visp.net.lb>
 <50A4606D.4020402@broadcom.com>
 <alpine.DEB.2.00.1211141929510.14414@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1211141929510.14414@chino.kir.corp.google.com>
X-WSS-ID: 7CBABBFD1QK2812891-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/14/2012 07:30 PM, David Rientjes wrote:
> On Wed, 14 Nov 2012, Nithin Nayak Sujir wrote:
>
>> This was fixed by
>>
>> commit de0a41484c47d783dd4d442914815076aa2caac2
>> Author: Paul Gortmaker <paul.gortmaker@windriver.com>
>> Date:   Mon Oct 1 11:43:49 2012 -0400
>>
>>      tg3: unconditionally select HWMON support when tg3 is enabled.
>>
> Would you mind submitting this for stable by following the procedure
> described in Documentation/stable_kernel_rules.txt?
>

Will do. Thank you for bringing this to our attention.

Nithin.


