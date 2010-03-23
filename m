Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab0CWQHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:07:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab0CWQHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:07:15 -0400
Message-ID: <4BA8E72F.2080402@redhat.com>
Date: Tue, 23 Mar 2010 12:07:11 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make kernel-doc ignore __init_or_module
References: <4BA8DEEA.7090102@redhat.com> <4BA8E0F8.4050708@oracle.com>
In-Reply-To: <4BA8E0F8.4050708@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2010 11:40 AM, Randy Dunlap wrote:
> On 03/23/10 08:31, William Cohen wrote:
>>
>> Function definitions may include __init_or_module. kernel-doc needs to
>> filter those out to avoid confusing __init_or_module for the function name.
>>
>> Signed-off-by: William cohen <wcohen@redhat.com>
>> ---
>>  scripts/kernel-doc |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
>> index c7865c3..1d8db58 100755
>> --- a/scripts/kernel-doc
>> +++ b/scripts/kernel-doc
>> @@ -1728,6 +1728,7 @@ sub dump_function($$) {
>>      $prototype =~ s/^noinline +//;
>>      $prototype =~ s/__devinit +//;
>>      $prototype =~ s/__init +//;
>> +    $prototype =~ s/__init_or_module +//;
>>      $prototype =~ s/^#\s*define\s+//; #ak added
>>      $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
>>  
> 
> Hi,
> 
> Yes, I know.  I've already sent this patch to Linus more than once
> and now Andrew has it for merging...
> 

Thanks, Randy. -Will
