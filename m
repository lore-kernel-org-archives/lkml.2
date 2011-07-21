Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab1GUI3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 04:29:09 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:36623 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab1GUI3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 04:29:06 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E27E351.5060604@cam.ac.uk>
Date: Thu, 21 Jul 2011 09:29:05 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Boiler plate functions for ida / idr allocation?
References: <4E1D6900.6040500@cam.ac.uk> <20110713133139.GO2872@htj.dyndns.org> <4E1DA232.30408@cam.ac.uk> <878vrs2if3.fsf@rustcorp.com.au> <20110721081946.GB3455@htj.dyndns.org>
In-Reply-To: <20110721081946.GB3455@htj.dyndns.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/11 09:19, Tejun Heo wrote:
> On Thu, Jul 21, 2011 at 05:07:36PM +0930, Rusty Russell wrote:
>> From: Rusty Russell <rusty@rustcorp.com.au>
>> Subject: ida: Simplified functions for id allocation.
>>
>> The current hyper-optimized functions are overkill if you simply want
>> to allocate an id for a device.  Create versions which use an internal
>> lock.
>>
>> Thanks to Tejun for feedback.  Feel free to delete the #ifdef TEST
>> code.
>>
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ...
>>  static struct kmem_cache *idr_layer_cache;
>> +static DEFINE_SPINLOCK(simple_ida);
> 
> I think the name is a bit confusing.  Maybe simple_ida_lock is better?
> Other than that,
> 
>  Acked-by: Tejun Heo <tj@kernel.org>
> 
> I guess this is best routed through -mm?
> 
> Thanks.
> 
Thanks Rusty. Just what I was looking for. I'll push out some patches using
this once it's picked up.

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

