Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842Ab2C2UIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:08:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39730 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933805Ab2C2UHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:07:51 -0400
Message-ID: <4F74C10B.3040503@zytor.com>
Date: Thu, 29 Mar 2012 13:07:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Maarten ter Huurne <maarten@treewalker.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/mem: Add kernel config option to omit this device.
References: <1333041724-20532-1-git-send-email-maarten@treewalker.org> <4F749C26.60804@zytor.com> <1679935.Pf8rWZIDTT@hyperion>
In-Reply-To: <1679935.Pf8rWZIDTT@hyperion>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 12:32 PM, Maarten ter Huurne wrote:
> On Thursday 29 March 2012 10:30:14 H. Peter Anvin wrote:
>> On 03/29/2012 10:22 AM, Maarten ter Huurne wrote:
>>> Many systems don't need /dev/mem, so make it optional.
>>> It saves some space on embedded systems.
>>>
>>> Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
>>
>> I would like to see it being modular if it is made optional.  I think
>> that would be the right thing anyway.
> 
> By modular, do you mean splitting off the code from drivers/char/mem.c into 
> a new source file?
> 
> In mem.c there are several static functions used by more than one device, 
> but I think /dev/mem, /dev/kmem and /dev/port are relatively independent of 
> the other devices, so splitting off those three would be an option.
> 

Yes, splitting them and making it possible to compile them as modules.

And certainly the devices you list above are really quite different
from, say /dev/null or /dev/zero.

	-hpa

