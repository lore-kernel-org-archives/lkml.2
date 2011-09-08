Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab1IHKcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 06:32:42 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:32907
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab1IHKcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 06:32:41 -0400
Message-ID: <4E6899C7.20105@kernel.dk>
Date: Thu, 08 Sep 2011 12:32:39 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] elevator.c: use ELV_NAME_MAX instead of magic number
 16 for chosen_elevator
References: <4E637BA8.6030300@gmail.com> <4E684331.501@gmail.com>
In-Reply-To: <4E684331.501@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-08 06:23, Wang Sheng-Hui wrote:
> On 2011年09月04日 21:22, Wang Sheng-Hui wrote:
>> We have ELV_NAME_MAX defined to 16, and hence we should use it
>> instead of the magic nubmer 16 for elevator's name string.
>>
>> The patch is against 3.1-rc3.
>>
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>> ---
>>  block/elevator.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/block/elevator.c b/block/elevator.c
>> index a3b64bc..cb332cb 100644
>> --- a/block/elevator.c
>> +++ b/block/elevator.c
>> @@ -182,7 +182,7 @@ static void elevator_attach(struct request_queue *q, struct elevator_queue *eq,
>>  	eq->elevator_data = data;
>>  }
>>  
>> -static char chosen_elevator[16];
>> +static char chosen_elevator[ELV_NAME_MAX];
>>  
>>  static int __init elevator_setup(char *str)
>>  {
> 
> Any comment?

Looks fine, applied.

-- 
Jens Axboe

