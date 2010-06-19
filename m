Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab0FSMtG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 08:49:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:48775 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab0FSMtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 08:49:04 -0400
Message-ID: <4C1CBC8C.8060004@kernel.org>
Date: Sat, 19 Jun 2010 14:48:12 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andy Walls <awalls@md.metrocast.net>,
       Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <87vd9fo1sk.fsf@basil.nowhere.org> <4C1C8263.9040404@kernel.org> <87fx0jo0z6.fsf@basil.nowhere.org> <4C1C8772.8090406@kernel.org> <20100619090851.GF18946@basil.fritz.box> <4C1C8A18.2030709@kernel.org> <20100619091518.GG18946@basil.fritz.box> <4C1C8B32.1040007@kernel.org> <20100619092758.GH18946@basil.fritz.box> <4C1C911B.6040601@kernel.org> <20100619122010.GI18946@basil.fritz.box>
In-Reply-To: <20100619122010.GI18946@basil.fritz.box>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Jun 2010 12:48:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2010 02:20 PM, Andi Kleen wrote:
>> * Do machines ever report that many MCE errors?  The usual rate seems
>>   like one per weeks or months even when they're frequent.
> 
> Yes you can even get a flood when the system or parts 
> of the system is dying. There's some throttling in the error handling, 
> but yes in some cases you can get high rates.
> 
>> * If a machine is actually reporting enough errors to overwhelm single
>>   error handling thread, does it even matter what we do?
> 
> There are cases where you can have many errors but still survive.

Alright, adding to todo list.

Thanks.

-- 
tejun
