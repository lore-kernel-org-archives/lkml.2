Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab1FXMLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 08:11:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:55695 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1FXMLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 08:11:22 -0400
Message-ID: <4E047EE6.2030505@windriver.com>
Date: Fri, 24 Jun 2011 08:11:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: "J. R. Okajima" <hooanon05@yahoo.co.jp>, <stable@kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable-review@kernel.org>
Subject: Re: [34-longterm 100/247] NFS: fix the return value of nfs_file_fsync()
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>	 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>	 <1308850515-15242-41-git-send-email-paul.gortmaker@windriver.com>	 <3853.1308880989@jrobl> <1308881159.30166.0.camel@lade.trondhjem.org>
In-Reply-To: <1308881159.30166.0.camel@lade.trondhjem.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-06-23 10:05 PM, Trond Myklebust wrote:
> On Fri, 2011-06-24 at 11:03 +0900, J. R. Okajima wrote: 
>> Paul Gortmaker:
>>> By the commit af7fa16 2010-08-03 NFS: Fix up the fsync code
>>> close(2) became returning the non-zero value even if it went well.
>>> nfs_file_fsync() should return 0 when "status" is positive.
>>>
>>> [PG: in 34, nfs_file_fsync is just a wrapper around nfs_do_fsync,
>>>  so the related code and actual change lands in nfs_do_fsync here.]
>>
>> In these 247 patches, I could not find the backport of
>> 	af7fa16 2010-08-03 NFS: Fix up the fsync code
>> If you bring the commit af7fa16 into 2.6.34.10, then you will need this
>> one (0702099bd in upstream) too. Otherwise I am afraid it is
>> unnecessary.
>> But I'd ask a reply from Trond Myklebust.
> 
> I agree.

Thanks guys!  I'll queue 0702099bd86c33c2dcdbd3963433a61f3f503901
for 34.10

Paul.

> 
> Cheers
>   Trond
> 
