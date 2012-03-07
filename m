Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab2CGGBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 01:01:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50812 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab2CGGBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 01:01:12 -0500
Message-ID: <4F56F99E.3000206@gmail.com>
Date: Wed, 07 Mar 2012 14:01:02 +0800
From: Zhengwang Ruan <ruan.zhengwang@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: gregkh@linuxfoundation.org, arve@android.com, chris+android@zenthought.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Staging:android: Initialise buffer and buffer_size
 before used
References: <1331087818-9942-1-git-send-email-ruan.zhengwang@gmail.com> <1331087818-9942-2-git-send-email-ruan.zhengwang@gmail.com> <20120307060017.GP22598@mwanda>
In-Reply-To: <20120307060017.GP22598@mwanda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




-------- Original Message --------
From: Dan Carpenter
Sent: 2012年03月07日 星期三 09时00分17秒
To: Zhengwang Ruan
Subject: Re: [PATCH 2/2 v2] Staging:android: Initialise buffer and
buffer_size before used
> On Wed, Mar 07, 2012 at 10:36:58AM +0800, Zhengwang Ruan wrote:
>> GCC warns 'buffer' and 'buffer_size' are used with being uninitialized, and
>> 'buffer' is used as returned value, and 'buffer_size' is initialized using
>> uninitialized_var to clear warning.
>>
>> Signed-off-by: Zhengwang Ruan<ruan.zhengwang@gmail.com>
> These are resends.  Why are you resending these?

I found I did not send this patch to everyone listed by 
get_maintainer.pl, and I didn't get any response, so I made another try 
today. :-)

Thanks,
-Zhengwang

> regards,
> dan carpenter
>

