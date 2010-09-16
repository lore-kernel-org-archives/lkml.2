Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab0IPTVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:21:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40718 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab0IPTVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:21:47 -0400
Message-ID: <4C926DFC.1090600@zytor.com>
Date: Thu, 16 Sep 2010 12:20:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Ian Kent <raven@themaw.net>,
        autofs@linux.kernel.org
Subject: Re: [PATCH 04/12] BKL: Remove BKL from autofs4
References: <1284659185-8942-1-git-send-email-arnd@arndb.de> <1284659185-8942-5-git-send-email-arnd@arndb.de> <4C9258C1.3060906@zytor.com> <201009161955.48854.arnd@arndb.de>
In-Reply-To: <201009161955.48854.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2010 10:55 AM, Arnd Bergmann wrote:
> On Thursday 16 September 2010 19:49:53 H. Peter Anvin wrote:
>> On 09/16/2010 10:46 AM, Arnd Bergmann wrote:
>>> autofs4 uses the BKL only to guard its ioctl operations.
>>> This can be trivially converted to use a mutex, as we have
>>> done with most device drivers before.
>>>
>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>>> ---
>>>  fs/autofs4/root.c |   12 +++++++-----
>>>  1 files changed, 7 insertions(+), 5 deletions(-)
>>
>> You may want to Cc: the maintainer, Ian Kent.
> 
> Ah, sorry about this. I looked at the wrong MAINTAINERS entry.
> 
> I also forgot to Cc you about autofs3, adding more to the confusion. ;)
> 
> Do you think the time has come to move autofs3 to drivers/staging
> as we deprecate the BKL?
> 

I'm leaving that up to Ian.  I have offered for years to just plain kill
off autofs3.

	-hpa
