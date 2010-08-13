Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0HMHPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 03:15:46 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54324 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab0HMHPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 03:15:43 -0400
Message-ID: <4C64F112.8050504@canonical.com>
Date: Fri, 13 Aug 2010 15:15:30 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Corentin Chary <corentin.chary@gmail.com>
CC: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] ideapad-laptop: add new driver
References: <1281672482-10909-1-git-send-email-ike.pan@canonical.com>	<AANLkTikBZ2SmqWavZ8bw69yQ_A5GTTcB13RKEzUuUcx3@mail.gmail.com>	<4C64EC01.9040103@canonical.com> <AANLkTim9jcbRwZt7E0gwVwQyETAEhe-tKP3NvGSAPknX@mail.gmail.com>
In-Reply-To: <AANLkTim9jcbRwZt7E0gwVwQyETAEhe-tKP3NvGSAPknX@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2010 03:01 PM, Corentin Chary wrote:
>> Could you point me where is the rfkill driver? Sorry I do not find it.
>>
>> I will see what I can do.
>>
>> Thanks.
>>
> 
> Here is the thread
> http://thread.gmane.org/gmane.linux.drivers.platform.x86.devel/471
> 
Yes, I believe I can. will read patch from David and merge.

But I think i will not use \_SB_.SECN as major interface. I know there is
another command code of EC that can access HW switch status and shutdown
the interface.


