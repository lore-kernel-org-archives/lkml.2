Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab2CGGQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 01:16:31 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48488 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2CGGQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 01:16:30 -0500
Message-ID: <4F56FD34.1090103@gmail.com>
Date: Wed, 07 Mar 2012 14:16:20 +0800
From: Zhengwang Ruan <ruan.zhengwang@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: arve@android.com, chris+android@zenthought.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Staging:android: Initialise buffer and buffer_size
 before used
References: <1331087818-9942-1-git-send-email-ruan.zhengwang@gmail.com> <1331087818-9942-2-git-send-email-ruan.zhengwang@gmail.com> <20120307054616.GA7775@kroah.com>
In-Reply-To: <20120307054616.GA7775@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




-------- Original Message --------
From: Greg KH
Sent: 2012年03月06日 星期二 21时46分16秒
To: Zhengwang Ruan
Subject: Re: [PATCH 2/2 v2] Staging:android: Initialise buffer and
buffer_size before used
> On Wed, Mar 07, 2012 at 10:36:58AM +0800, Zhengwang Ruan wrote:
>> GCC warns 'buffer' and 'buffer_size' are used with being uninitialized, and
>> 'buffer' is used as returned value, and 'buffer_size' is initialized using
>> uninitialized_var to clear warning.
> Doesn't say that for me at all, what version of gcc are you using?  I'm
> using 4.6.2 here, and if you are using an older version, then please
> upgrade to one smarter than the one you are using.
>
> As you are trying to paper over gcc issues, I can't take this patch,
> sorry.
>

Ok, I will make another try after updating GCC to 4.6. Thank you for 
your effort!

Thanks,
-Zhengwang

> greg k-h
>

