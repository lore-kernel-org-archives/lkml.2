Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195Ab2HXT6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:58:43 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4115 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760169Ab2HXT6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 15:58:38 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <5037DCE3.2010505@broadcom.com>
Date: Fri, 24 Aug 2012 21:58:27 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-Version: 1.0
To: "Aaron Lu" <aaron.lwe@gmail.com>
cc: linux-mmc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Philip Rakity" <prakity@marvell.com>
Subject: Re: v3.6-rc1: modprobe hangs with sdhci failure on dell e6410
References: <5034E895.4050105@broadcom.com>
 <CAOzJMDTTAzzV3VHgvY6B3ooe1ZyWkRGvfDgbFw4ZonQJFu3uAQ@mail.gmail.com>
 <50373A31.7040803@broadcom.com>
In-Reply-To: <50373A31.7040803@broadcom.com>
X-WSS-ID: 7C2903FA49823170460-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 10:24 AM, Arend van Spriel wrote:
> On 08/23/2012 04:58 PM, Aaron Lu wrote:
>> On Wed, Aug 22, 2012 at 10:11 PM, Arend van Spriel
>> <arend@broadcom.com> wrote:
>>> A quick search using google did not provide clues. Regardless if
>>> there is
>>> anything inserted the hang occurs.
>>>
>>> Gr. AvS
>>
>> Also, your .config might be helpful.
>
> True. Here it is.
>
> Gr. AvS

Inspected the logs on another machine running the same kernel and it has 
the same issue. I was not using the mmc slot on that machine so I was 
not aware. On x86_64 I am not seeing the issue (so far).

Gr. AvS

