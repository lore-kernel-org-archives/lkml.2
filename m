Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab2FODEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 23:04:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624Ab2FODEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 23:04:50 -0400
Message-ID: <4FDAA69E.9000405@redhat.com>
Date: Fri, 15 Jun 2012 11:06:06 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: NULL pointer dereference at blk_drain_queue
References: <4FD9A908.90307@suse.cz> <4FD9ABFE.8060603@kernel.dk> <4FD9B1F7.1040107@suse.cz> <4FD9E508.8090405@redhat.com> <4FD9E572.4000800@suse.cz>
In-Reply-To: <4FD9E572.4000800@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 09:21 PM, Jiri Slaby wrote:
> On 06/14/2012 03:20 PM, Asias He wrote:
>> On 06/14/2012 05:42 PM, Jiri Slaby wrote:
>>> On 06/14/2012 11:16 AM, Jens Axboe wrote:
>>>> On 06/14/2012 11:04 AM, Jiri Slaby wrote:
>>>>> with today's -next I'm (reproducibly) getting this while updating
>>>>> packages:
> ...
>> Jiri, good to hear this fixes for you. BTW. How do you trigger this issue?
>
> On opensuse factory, by zypper dup. It always died at the point of
> updating udev or multipath package.

OK.

-- 
Asias


