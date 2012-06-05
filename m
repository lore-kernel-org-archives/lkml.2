Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab2FESLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 14:11:34 -0400
Received: from masquerade.micron.com ([137.201.242.130]:54064 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2FESLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 14:11:33 -0400
Message-ID: <4FCE4BD0.8030703@micron.com>
Date: Tue, 5 Jun 2012 11:11:28 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 2/2] mtip32xx: Create debugfs entries for troubleshooting
References: <4FCD1002.2060203@micron.com> <4FCDB29F.8060107@kernel.dk> <4FCE49EE.2070703@micron.com>
In-Reply-To: <4FCE49EE.2070703@micron.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18948.005
X-TM-AS-Result: No--9.311700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/2012 11:03 AM, Asai Thambi S P wrote:

> On 6/5/2012 12:17 AM, Jens Axboe wrote:
> 
>> On 06/04/2012 09:44 PM, Asai Thambi S P wrote:
>>> @@ -4062,10 +4210,20 @@ static int __init mtip_init(void)
>>>  	}
>>>  	mtip_major = error;
>>>  
>>> +	if (!dfs_parent) {
>>> +		dfs_parent = debugfs_create_dir("rssd", NULL);
>>> +		if (IS_ERR_OR_NULL(dfs_parent)) {
>>> +			printk(KERN_WARNING "Error creating debugfs parent\n");
>>> +			dfs_parent = NULL;
>>> +		}
>>> +	}
>>> +
>>
>> Why would dfs_parent ever be non-NULL here?
>>
>> Apart from that, looks fine.
>>
> 
> I moved this part from mtip_hw_debugfs_init(), dfs_parent will not be NULL here.
> 


dfs_parent will be NULL here :)

--
Regards,
Asai Thambi
