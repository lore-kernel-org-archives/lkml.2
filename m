Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0F2N2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 09:28:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab0F2N2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 09:28:09 -0400
Message-ID: <4C29F4E5.4070008@suse.cz>
Date: Tue, 29 Jun 2010 15:28:05 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nicolas Palix <npalix@diku.dk>
Cc: Kulikov Vasiliy <segooon@gmail.com>, trivial@kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>, Julia Lawall <julia@diku.dk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: fix ubuntu distro name
References: <1277814677-1944-1-git-send-email-segooon@gmail.com> <201006291457.13795.npalix@diku.dk>
In-Reply-To: <201006291457.13795.npalix@diku.dk>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.6.2010 14:57, Nicolas Palix wrote:
> 
> The version in Karmic is too old. The right correction is indeed Lucid Lynx.
> 
> On Tuesday 29 June 2010 14:31:16 Kulikov Vasiliy wrote:
>> 10.04 is Lucid, not Karmic.
>>
>> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
>> ---
>>  Documentation/coccinelle.txt |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
>> index ba3315d..cd2b028 100644
>> --- a/Documentation/coccinelle.txt
>> +++ b/Documentation/coccinelle.txt
>> @@ -14,7 +14,7 @@ of many distributions, e.g. :
>>  
>>   - Debian (>=squeeze)
>>   - Fedora (>=13)
>> - - Ubuntu (>=10.04 Karmic Koala)
>> + - Ubuntu (>=10.04 Lucid Lynx)
>>   - OpenSUSE
>>   - Arch Linux
>>   - NetBSD
>>
> 
> Acked-by: Nicolas Palix <npalix@diku.dk>

Applied.

Michal
