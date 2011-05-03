Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab1ECSMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 14:12:13 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:37552 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753884Ab1ECSMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 14:12:12 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DC04546.50901@verizon.net>
Date: Tue, 3 May 2011 14:11:18 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: <linux-kernel@vger.kernel.org>, <hjanssen@microsoft.com>,
        <haiyangz@microsoft.com>
Subject: Re: [PATCH] staging: hv: make HYPERV_UTILS depend on NLS to prevent
 a build error
References: <4DB60932.6090000@verizon.net> <20110503175703.GA19082@kroah.com>
In-Reply-To: <20110503175703.GA19082@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/2011 1:57 PM, Greg KH wrote:
> On Mon, Apr 25, 2011 at 07:52:18PM -0400, Peter Foley wrote:
>> This patch adds a dependency on NLS to HYPERV_UTILS to avoid a build error.
>>
>> Signed-off-by: Peter Foley <pefoley2@verizon.net>
>> ---
>>  drivers/staging/hv/Kconfig |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/staging/hv/Kconfig b/drivers/staging/hv/Kconfig
>> index d41f380..76f0756 100644
>> --- a/drivers/staging/hv/Kconfig
>> +++ b/drivers/staging/hv/Kconfig
>> @@ -31,7 +31,7 @@ config HYPERV_NET
>>   config HYPERV_UTILS
>>  	tristate "Microsoft Hyper-V Utilities driver"
>> -	depends on CONNECTOR
>> +	depends on CONNECTOR && NLS
> 
> This patch doesn't apply at all, and I can't figure out why.  Did your
> email client somehow mess it up?
> 
> Care to resend it, with the proper information in the Changelog entry
> (i.e. what build error this is fixing) so I can apply it?
> 
> thanks,
> 
> greg k-h

Ok, I'll resend it.
I seem to have a problem with my email client corrupting patches.
I'm going to try a different one which will hopefully fix the problem.

Thanks,

Peter
